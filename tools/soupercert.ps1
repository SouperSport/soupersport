param(
  [Parameter(Mandatory = $true)]
  [string] $SealedInputPath,

  [Parameter(Mandatory = $true)]
  [string] $InitialStatePath,

  [Parameter(Mandatory = $true)]
  [string] $OutCertPath
)

$ErrorActionPreference = "Stop"

function Sha256Hex([byte[]] $bytes) {
  $sha = [System.Security.Cryptography.SHA256]::Create()
  try {
    ($sha.ComputeHash($bytes) | ForEach-Object { $_.ToString("x2") }) -join ""
  }
  finally {
    $sha.Dispose()
  }
}

function ReadBytes([string] $path) {
  $resolved = Resolve-Path -LiteralPath $path
  [System.IO.File]::ReadAllBytes($resolved)
}

function CanonicalJson([object] $obj) {
  # For ordered dictionaries / [ordered] hashtables, ConvertTo-Json preserves insertion order.
  # -Compress reduces whitespace variance.
  $obj | ConvertTo-Json -Depth 20 -Compress
}

# --- Inputs (assumed already sealed/canonical upstream for this proof-of-workflow) ---
$sealedBytes = ReadBytes $SealedInputPath
$stateBytes  = ReadBytes $InitialStatePath

$inputs_hash        = Sha256Hex $sealedBytes
$initial_state_hash = Sha256Hex $stateBytes

$sealed = Get-Content -LiteralPath $SealedInputPath -Raw | ConvertFrom-Json
$state  = Get-Content -LiteralPath $InitialStatePath -Raw | ConvertFrom-Json

# --- Deterministic evaluation stub (explicit outcomes + trace) ---
# Rule: parse sealed.amount as integer.
# Outcome is explicit:
#   { ok: true, value: int }
#   { ok: false, error: { code, message } }

$trace = New-Object System.Collections.Generic.List[object]
$trace.Add([ordered]@{ event = "enter"; region = "Deterministic" })

$outcome = $null

try {
  $trace.Add([ordered]@{ event = "read_input"; field = "amount" })

  if ($null -eq $sealed.amount) {
    $trace.Add([ordered]@{ event = "error"; code = "MISSING_FIELD" })
    $outcome = [ordered]@{
      ok    = $false
      error = [ordered]@{ code = "MISSING_FIELD"; message = "amount is required" }
    }
  }
  else {
    $s = [string] $sealed.amount
    $trace.Add([ordered]@{ event = "parse_int"; value = $s })

    $n = 0
    if (-not [int]::TryParse($s, [ref] $n)) {
      $trace.Add([ordered]@{ event = "error"; code = "PARSE_ERROR" })
      $outcome = [ordered]@{
        ok    = $false
        error = [ordered]@{ code = "PARSE_ERROR"; message = "amount must be an integer" }
      }
    }
    else {
      $trace.Add([ordered]@{ event = "success"; value = $n })
      $outcome = [ordered]@{
        ok    = $true
        value = $n
      }
    }
  }
}
finally {
  $trace.Add([ordered]@{ event = "exit"; region = "Deterministic" })
}

# --- Hash the canonical outcome and canonical trace ---
$outcomeJson = CanonicalJson $outcome
$traceJson   = CanonicalJson $trace

$output_hash = Sha256Hex ([System.Text.Encoding]::UTF8.GetBytes($outcomeJson))
$trace_hash  = Sha256Hex ([System.Text.Encoding]::UTF8.GetBytes($traceJson))

# --- Determinism certificate (stable JSON) ---
$cert = [ordered]@{
  law                = "Deterministic Replayability"
  inputs_hash         = $inputs_hash
  initial_state_hash  = $initial_state_hash
  output_hash         = $output_hash
  trace_hash          = $trace_hash
  numeric_profile     = "strict-stub"
}

$certJson = CanonicalJson $cert

# Write certificate with UTF-8 (no BOM), stable representation
Set-Content -LiteralPath $OutCertPath -Value $certJson -NoNewline -Encoding utf8
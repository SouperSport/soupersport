param(
  [Parameter(Mandatory=$true)][string]$PublicKeyJsonPath,
  [string]$CasesPath = "examples/cases.yml",
  [ValidateSet("warn","strict")][string]$Mode = "warn"
)

$ErrorActionPreference = "Stop"

function ParseCasesYaml([string]$path) {
  if (-not (Test-Path -LiteralPath $path)) { throw "Cases manifest not found: $path" }
  $lines = Get-Content -LiteralPath $path

  $cases = @()
  $current = $null

  foreach ($line in $lines) {
    $t = $line.Trim()
    if ($t -eq "" -or $t.StartsWith("#")) { continue }

    if ($t -like "- name:*") {
      if ($null -ne $current) { $cases += $current }
      $name = $t.Substring($t.IndexOf(":") + 1).Trim()
      $current = [ordered]@{ name=$name; golden_cert=$null }
      continue
    }
    if ($null -eq $current) { continue }

    if ($t -like "golden_cert:*") {
      $current.golden_cert = $t.Substring($t.IndexOf(":") + 1).Trim()
      continue
    }
  }
  if ($null -ne $current) { $cases += $current }

  foreach ($c in $cases) {
    if ($null -eq $c.golden_cert -or $c.golden_cert.Trim() -eq "") {
      throw "Case '$($c.name)' missing golden_cert in $path"
    }
  }
  return $cases
}

function Warn([string]$msg) {
  Write-Host "::warning::$msg"
}

$cases = ParseCasesYaml $CasesPath
Write-Host ("Provenance verification mode: {0}" -f $Mode)
Write-Host ("Found {0} case(s) in {1}" -f $cases.Count, $CasesPath)

$anyWarn = $false

foreach ($c in $cases) {
  $p = $c.golden_cert
  if (-not (Test-Path -LiteralPath $p)) {
    $msg = "Missing golden certificate for case '$($c.name)': $p"
    if ($Mode -eq "strict") { throw $msg } else { Warn $msg; $anyWarn=$true; continue }
  }

  try {
    pwsh -NoProfile -ExecutionPolicy Bypass -File tools/verify-provenance.ps1 -CertPath $p -PublicKeyJsonPath $PublicKeyJsonPath | Out-Host
  }
  catch {
    $msg = "Provenance signature check failed for '$($c.name)' ($p): $($_.Exception.Message)"
    if ($Mode -eq "strict") { throw $msg } else { Warn $msg; $anyWarn=$true }
  }
}

if ($anyWarn -and $Mode -eq "warn") {
  Write-Host "Provenance verification completed with warnings (warn mode)."
} else {
  Write-Host "Provenance verification completed."
}
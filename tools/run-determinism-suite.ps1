param(
  [string]$CasesPath = "examples/cases.yml",
  [string]$CounterfactualMode = "alt"
)

$ErrorActionPreference = "Stop"

function ParseCasesYaml([string]$path) {
  if (-not (Test-Path -LiteralPath $path)) {
    throw "Cases manifest not found: $path"
  }

  $lines = Get-Content -LiteralPath $path

  $cases = @()
  $current = $null

  foreach ($line in $lines) {
    $t = $line.Trim()

    if ($t -eq "" -or $t.StartsWith("#")) { continue }

    # Start of a new case: "- name: case01"
    if ($t -like "- name:*") {
      if ($null -ne $current) { $cases += $current }
      $name = $t.Substring($t.IndexOf(":") + 1).Trim()
      $current = [ordered]@{
        name = $name
        sealed_input = $null
        initial_state = $null
        golden_cert = $null
      }
      continue
    }

    if ($null -eq $current) { continue }

    # Key/value lines: "sealed_input: path"
    if ($t -like "sealed_input:*") {
      $current.sealed_input = $t.Substring($t.IndexOf(":") + 1).Trim()
      continue
    }
    if ($t -like "initial_state:*") {
      $current.initial_state = $t.Substring($t.IndexOf(":") + 1).Trim()
      continue
    }
    if ($t -like "golden_cert:*") {
      $current.golden_cert = $t.Substring($t.IndexOf(":") + 1).Trim()
      continue
    }
  }

  if ($null -ne $current) { $cases += $current }

  # Validate
  foreach ($c in $cases) {
    foreach ($k in @("name","sealed_input","initial_state","golden_cert")) {
      if ($null -eq $c[$k] -or $c[$k].ToString().Trim() -eq "") {
        throw "Case '$($c.name)' missing required field '$k' in $path"
      }
    }
  }

  return $cases
}

# --- Begin ---
Write-Host "Loading cases from: $CasesPath"
$cases = ParseCasesYaml $CasesPath
Write-Host ("Found {0} case(s)." -f $cases.Count)

# Enforce sealed-only inputs globally (same rule as CI)
& (Join-Path $PSScriptRoot "enforce-sealed-inputs.ps1")

$gen = Join-Path $PSScriptRoot "generate-cert.ps1"
$ver = Join-Path $PSScriptRoot "verify-golden-and-counterfactual.ps1"

foreach ($c in $cases) {
  Write-Host "=== Running case: $($c.name) ==="

  $baselineCert = "cert_$($c.name)_base.json"
  $cfCert       = "cert_$($c.name)_cf.json"

  # Baseline
  & $gen `
    -SealedInputPath  $c.sealed_input `
    -InitialStatePath $c.initial_state `
    -OutCertPath      $baselineCert

  # Counterfactual
  & $gen `
    -SealedInputPath  $c.sealed_input `
    -InitialStatePath $c.initial_state `
    -OutCertPath      $cfCert `
    -CounterfactualMode $CounterfactualMode

  # Verify golden + counterfactual equivalence
  & $ver `
    -GoldenCertPath        $c.golden_cert `
    -BaselineCertPath      $baselineCert `
    -CounterfactualCertPath $cfCert

  # Clean up run artifacts (keep workspace clean)
  Remove-Item -LiteralPath $baselineCert, $cfCert -ErrorAction SilentlyContinue

  Write-Host "=== Case passed: $($c.name) ==="
}

Write-Host "All determinism cases passed."

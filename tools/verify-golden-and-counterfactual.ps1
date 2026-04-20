param(
  [Parameter(Mandatory=$true)][string]$GoldenCertPath,
  [Parameter(Mandatory=$true)][string]$BaselineCertPath,
  [Parameter(Mandatory=$true)][string]$CounterfactualCertPath
)

$ErrorActionPreference = "Stop"

$golden = Get-Content -LiteralPath $GoldenCertPath -Raw | ConvertFrom-Json
$base   = Get-Content -LiteralPath $BaselineCertPath -Raw | ConvertFrom-Json
$cf     = Get-Content -LiteralPath $CounterfactualCertPath -Raw | ConvertFrom-Json

if ($golden.output_hash -ne $base.output_hash -or $golden.trace_hash -ne $base.trace_hash) {
  throw "Golden determinism violation."
}

if ($base.trace_hash -ne $cf.trace_hash) {
  throw "Counterfactual trace divergence."
}

Write-Host "Determinism OK: golden, baseline, and counterfactual traces match."
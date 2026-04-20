param(
  [Parameter(Mandatory=$true)][string]$SealedInputPath,
  [Parameter(Mandatory=$true)][string]$InitialStatePath,
  [Parameter(Mandatory=$true)][string]$OutCertPath,
  [string]$CounterfactualMode = ""
)

$ErrorActionPreference = "Stop"

# Preserve prior mode so the script is non-invasive
$prior = $env:SS_COUNTERFACTUAL_MODE

try {
  if ([string]::IsNullOrWhiteSpace($CounterfactualMode)) {
    Remove-Item Env:SS_COUNTERFACTUAL_MODE -ErrorAction SilentlyContinue
  } else {
    $env:SS_COUNTERFACTUAL_MODE = $CounterfactualMode
  }

  # Invoke the existing tool in the current host (PS 5.1 or PS 7)
  $souper = Join-Path $PSScriptRoot "soupercert.ps1"
  & $souper -SealedInputPath $SealedInputPath -InitialStatePath $InitialStatePath -OutCertPath $OutCertPath
}
finally {
  # Restore original env state
  if ($null -eq $prior -or $prior -eq "") {
    Remove-Item Env:SS_COUNTERFACTUAL_MODE -ErrorAction SilentlyContinue
  } else {
    $env:SS_COUNTERFACTUAL_MODE = $prior
  }
}
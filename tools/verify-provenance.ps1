param(
  [Parameter(Mandatory=$true)][string]$CertPath,
  [Parameter(Mandatory=$true)][string]$PublicKeyJsonPath
)

$ErrorActionPreference = "Stop"

function B64ToBytes([string]$s) {
  if ($null -eq $s -or $s.Trim() -eq "") { return $null }
  return [Convert]::FromBase64String($s)
}

function CanonicalJson([object]$obj) {
  $obj | ConvertTo-Json -Depth 20 -Compress
}

function CanonicalPayloadFromProv([object]$provPayload) {
  # Rebuild in fixed key order to match signer canonicalization
  return [ordered]@{
    payload_name        = $provPayload.payload_name
    payload_version     = $provPayload.payload_version
    law                 = $provPayload.law
    inputs_hash          = $provPayload.inputs_hash
    initial_state_hash   = $provPayload.initial_state_hash
    output_hash          = $provPayload.output_hash
    trace_hash           = $provPayload.trace_hash
    numeric_profile      = $provPayload.numeric_profile
    tool                = [ordered]@{
      name    = $provPayload.tool.name
      version = $provPayload.tool.version
    }
  }
}

$cert = Get-Content -LiteralPath $CertPath -Raw | ConvertFrom-Json
$k = Get-Content -LiteralPath $PublicKeyJsonPath -Raw | ConvertFrom-Json
if ($k.kty -ne "RSA") { throw "Unsupported key type in $PublicKeyJsonPath (expected kty=RSA)" }

if (-not ($cert.PSObject.Properties.Name -contains "provenance")) {
  throw "Missing provenance block in $CertPath"
}

$prov = $cert.provenance
if ($null -eq $prov.payload -or $null -eq $prov.signature -or $null -eq $prov.algorithm) {
  throw "Incomplete provenance block in $CertPath"
}
if ($prov.algorithm -ne "RSA-SHA256") {
  throw "Unsupported algorithm '$($prov.algorithm)' in $CertPath"
}

$params = New-Object System.Security.Cryptography.RSAParameters
$params.Modulus  = B64ToBytes $k.n
$params.Exponent = B64ToBytes $k.e

$rsa = [System.Security.Cryptography.RSA]::Create()
$rsa.ImportParameters($params)

$payload = CanonicalPayloadFromProv $prov.payload
$payloadJson = CanonicalJson $payload
$payloadBytes = [Text.Encoding]::UTF8.GetBytes($payloadJson)

$sigBytes = [Convert]::FromBase64String($prov.signature)

$ok = $rsa.VerifyData(
  $payloadBytes,
  $sigBytes,
  [System.Security.Cryptography.HashAlgorithmName]::SHA256,
  [System.Security.Cryptography.RSASignaturePadding]::Pkcs1
)

if (-not $ok) {
  throw "Invalid provenance signature in $CertPath"
}

Write-Host "Verified: $CertPath"
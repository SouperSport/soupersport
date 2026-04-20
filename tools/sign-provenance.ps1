param(
  [Parameter(Mandatory=$true)][string]$CertPath,
  [Parameter(Mandatory=$true)][string]$PrivateKeyJsonPath,
  [string]$ToolName = "soupercert",
  [string]$ToolVersion = "dev"
)

$ErrorActionPreference = "Stop"

function B64ToBytes([string]$s) {
  if ($null -eq $s -or $s.Trim() -eq "") { return $null }
  return [Convert]::FromBase64String($s)
}

function CanonicalPayload([object]$cert, [string]$toolName, [string]$toolVersion) {
  # Fixed key order = stable canonicalization
  return [ordered]@{
    payload_name        = "souper.provenance.deterministic-execution"
    payload_version     = "1.0.0"
    law                 = $cert.law
    inputs_hash          = $cert.inputs_hash
    initial_state_hash   = $cert.initial_state_hash
    output_hash          = $cert.output_hash
    trace_hash           = $cert.trace_hash
    numeric_profile      = $cert.numeric_profile
    tool                = [ordered]@{ name = $toolName; version = $toolVersion }
  }
}

function CanonicalJson([object]$obj) {
  $obj | ConvertTo-Json -Depth 20 -Compress
}

# Load certificate
$cert = Get-Content -LiteralPath $CertPath -Raw | ConvertFrom-Json

# Load private key params (RSAParameters in Base64 form)
$k = Get-Content -LiteralPath $PrivateKeyJsonPath -Raw | ConvertFrom-Json
if ($k.kty -ne "RSA") { throw "Unsupported key type in $PrivateKeyJsonPath (expected kty=RSA)" }

$params = New-Object System.Security.Cryptography.RSAParameters
$params.Modulus  = B64ToBytes $k.n
$params.Exponent = B64ToBytes $k.e
$params.D        = B64ToBytes $k.d
$params.P        = B64ToBytes $k.p
$params.Q        = B64ToBytes $k.q
$params.DP       = B64ToBytes $k.dp
$params.DQ       = B64ToBytes $k.dq
$params.InverseQ = B64ToBytes $k.qi

$rsa = [System.Security.Cryptography.RSA]::Create()
$rsa.ImportParameters($params)

$payload = CanonicalPayload $cert $ToolName $ToolVersion
$payloadJson = CanonicalJson $payload
$payloadBytes = [Text.Encoding]::UTF8.GetBytes($payloadJson)

$sigBytes = $rsa.SignData(
  $payloadBytes,
  [System.Security.Cryptography.HashAlgorithmName]::SHA256,
  [System.Security.Cryptography.RSASignaturePadding]::Pkcs1
)

$prov = [ordered]@{
  payload   = $payload
  signature = [Convert]::ToBase64String($sigBytes)
  algorithm = "RSA-SHA256"
}

# Attach / replace provenance
if ($cert.PSObject.Properties.Name -contains "provenance") {
  $cert.provenance = $prov
} else {
  $cert | Add-Member -NotePropertyName provenance -NotePropertyValue $prov
}

Set-Content -LiteralPath $CertPath -Value (CanonicalJson $cert) -NoNewline -Encoding utf8
Write-Host "Signed: $CertPath"

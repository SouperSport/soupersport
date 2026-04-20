param(
  [string]$RawInputPath = "raw_input.txt"
)

$ErrorActionPreference = "Stop"

if (Test-Path -LiteralPath $RawInputPath) {
  throw "Raw input detected: seal it before use ($RawInputPath)"
}
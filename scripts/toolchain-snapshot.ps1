# toolchain-snapshot.ps1
# Records the exact toolchain/runtime used to build/run the executor.

Write-Host "=== SouperSport Toolchain Snapshot ==="
Write-Host "Date: $(Get-Date -Format o)"
Write-Host ""

Write-Host "--- Environment ---"
Write-Host "MSYSTEM: $env:MSYSTEM"
Write-Host "PATH (first 3):"
$env:PATH.Split(';')[0..2] | ForEach-Object { "  $_" } | Write-Host

Write-Host ""
Write-Host "--- Compiler ---"
gfortran --version

Write-Host ""
Write-Host "--- Git ---"
git --version

Write-Host ""
Write-Host "--- MSYS2 packages (if pacman exists) ---"
if (Get-Command pacman -ErrorAction SilentlyContinue) {
  pacman -Q | Select-String -Pattern "gcc|gfortran|mingw-w64|msys2-runtime|ucrt|msvcrt"
} else {
  Write-Host "pacman not found in this shell."
}
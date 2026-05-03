if ($env:MSYSTEM -ne "MINGW64") {
    Write-Error "ERROR: Must run under MSYS2 MINGW64 environment."
    exit 1
}

.\souper_executor.exe
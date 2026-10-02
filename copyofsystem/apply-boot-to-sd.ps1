# Copy fixed boot config to SD card (bootfs = F: by default)
param(
    [string]$Drive = 'F'
)

$src = Join-Path $PSScriptRoot 'bootfs'
$dst = "${Drive}:\"

if (-not (Test-Path $dst)) {
    Write-Error "Drive ${Drive}: not found. Insert SD card and retry."
    exit 1
}

Write-Host "Copying boot config -> ${Drive}:\"
@('config.txt', 'cmdline.txt', 'hardware.dsi.txt', 'hardware.dsi-dsi0.txt', 'hardware.hats.txt') | ForEach-Object {
    Copy-Item (Join-Path $src $_) (Join-Path $dst $_) -Force
}
Write-Host "Done. Safely eject SD and boot Pi 5."

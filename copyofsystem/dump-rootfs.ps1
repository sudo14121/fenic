# Raw backup of ext4 root partition (partition 2) from Raspberry Pi SD card.
# Run as Administrator while SD card is inserted (Disk 2 in this session).
# Progress is logged to dump-rootfs.log

$ErrorActionPreference = 'Stop'
$logFile = Join-Path $PSScriptRoot 'dump-rootfs.log'
$outFile = Join-Path $PSScriptRoot 'rootfs.img'
$diskPath = '\\.\PhysicalDrive2'
$offset = 541065216
$size = 63547899904
$chunk = 4MB

function Write-Log($msg) {
    $line = "$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') $msg"
    Add-Content -Path $logFile -Value $line
    Write-Output $line
}

Write-Log "Starting rootfs dump -> $outFile"
Write-Log "Source: $diskPath offset=$offset size=$size bytes"

$src = [System.IO.File]::Open($diskPath, [System.IO.FileMode]::Open, [System.IO.FileAccess]::Read, [System.IO.FileShare]::ReadWrite)
try {
    $null = $src.Seek($offset, [System.IO.SeekOrigin]::Begin)
    $dst = [System.IO.File]::Open($outFile, [System.IO.FileMode]::Create, [System.IO.FileAccess]::Write, [System.IO.FileShare]::None)
    try {
        $buffer = New-Object byte[] $chunk
        $copied = 0L
        $sw = [System.Diagnostics.Stopwatch]::StartNew()
        while ($copied -lt $size) {
            $toRead = [Math]::Min($chunk, $size - $copied)
            $read = $src.Read($buffer, 0, [int]$toRead)
            if ($read -le 0) { throw "Unexpected EOF at $copied" }
            $dst.Write($buffer, 0, $read)
            $copied += $read
            if (($copied % (256MB)) -eq 0 -or $copied -eq $size) {
                $pct = [math]::Round(100.0 * $copied / $size, 1)
                $mbps = if ($sw.Elapsed.TotalSeconds -gt 0) { [math]::Round(($copied / 1MB) / $sw.Elapsed.TotalSeconds, 1) } else { 0 }
                Write-Log "Progress: $pct% ($([math]::Round($copied/1GB,2)) GB) avg ${mbps} MB/s"
            }
        }
        Write-Log "Done. rootfs.img size=$copied bytes"
    } finally {
        $dst.Close()
    }
} finally {
    $src.Close()
}

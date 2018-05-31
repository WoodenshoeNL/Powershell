#Parameters
Param(
   [switch]$DeleteDownloads
) #end param

##Init Arrays

$iisLogs = @(
    "C:\inetpub\logs\LogFiles"
)

$cleanupDirs = @(
    "C:\Program Files\Microsoft Data Protection Manager\DPM\Temp",
    "C:\ProgramData\Microsoft\Windows\WER\ReportQueue",
    "C:\ProgramData\Microsoft\Windows\WER\ReportArchive",
    "C:\Windows\SoftwareDistribution\Download",
    "C:\Windows\ccmcache",
    "C:\Windows\Temp",
    "C:\WER\ReportQueue",
    "C:\WER\ReportArchive",
    "C:\temp"
)

$userDownloads = @(
    "C:\Users\*\Downloads"
)

##Start Clean up

foreach ($dir in $cleanupDirs) {
    if (Test-Path $dir ) {
        Write-Host "[*] Folder found: $dir" -ForegroundColor "green"
        $teller = 0
        foreach ($item in Get-ChildItem -Path $dir) {
            if ($item.LastWriteTime -lt (Get-Date).AddDays(-14)) {
                $teller++
                Remove-Item $item.FullName -Force -Recurse -ErrorAction ignore
            }
        }
        Write-Host "[-] $teller Items removed" -ForegroundColor "DarkYellow"
    }
    
}

foreach ($dir in $iisLogs) {
    if (Test-Path $dir ) {
        foreach ($folder in Get-ChildItem -Path $dir) {
            Write-Host "[*] Folder found: $($folder.fullname)" -ForegroundColor "green"
            $teller = 0
            foreach ($item in Get-ChildItem -Path $folder.fullname) {
                if ($item.LastWriteTime -lt (Get-Date).AddDays(-14)) {
                    $teller++
                    #$item.FullName
                    Remove-Item $item.FullName -Force -ErrorAction ignore
                }
            }
            Write-Host "[-] $teller Items removed" -ForegroundColor "DarkYellow"
        }
    }
}

foreach ($dir in $userDownloads) {
    if (Test-Path $dir ) {
        foreach ($folder in Get-ChildItem -Path $dir) {
            if (Test-Path  $folder.fullname ) {
                Write-Host "[*] Folder found: $($folder.fullname)" -ForegroundColor "green"
                $teller = 0
                foreach ($item in Get-ChildItem -Path $folder.fullname) {
                    if ($item.LastWriteTime -lt (Get-Date).AddDays(-30)) {
                        $teller++
                        $item.FullName
                        Write-Host "[+] File found: $($item.fullname)" -ForegroundColor "Yellow"
                        if($DeleteDownloads){
                            Remove-Item $item.FullName -Force -ErrorAction ignore
                        }
                    }
                }
                Write-Host "[-] $teller Items found" -ForegroundColor "DarkYellow"
            }
        }
    }
}
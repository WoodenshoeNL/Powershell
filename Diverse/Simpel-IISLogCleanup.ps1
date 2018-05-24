foreach ($File in Get-ChildItem -Path "c:\inetpub\logs\LogFiles\W3SVC1") {
    if ($File.LastWriteTime -lt (Get-Date).AddDays(-30)) 
    {
       Remove-Item $File.FullName
    }
 }
 foreach ($File in Get-ChildItem -Path "c:\inetpub\logs\LogFiles\W3SVC2") {
    if ($File.LastWriteTime -lt (Get-Date).AddDays(-30)) 
    {
       Remove-Item $File.FullName
    }
 }
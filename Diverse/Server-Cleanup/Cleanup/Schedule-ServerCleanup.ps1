
$CleanupTaskName = "Disk Cleanup Script - Daily" 
$Cleanupaction = New-ScheduledTaskAction -Execute 'Powershell.exe' -Argument '-nologo -noprofile -noninteractive -command C:\script\Cleanup\server-cleanup.ps1'
$Cleanuptrigger =  New-ScheduledTaskTrigger -Daily -At 6am

$principal = New-ScheduledTaskPrincipal -UserID "NT AUTHORITY\SYSTEM" -LogonType ServiceAccount -RunLevel Highest

Register-ScheduledTask -Action $Cleanupaction -Trigger $Cleanuptrigger -TaskName $CleanupTaskName -Description "Run Disk Cleanup script" -Principal $principal


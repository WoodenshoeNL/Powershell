

$EnableTime = Get-Date -date "24-06-2018 15:00"
$DisableTime = Get-Date -date "23-06-2018 20:00"


$enableTaskName = "EnableMMSubscriptions_{0}" -f $(get-date -date $EnableTime -UFormat "%d-%m-%Y")
$DisableTaskName = "DisableMMSubscriptions_{0}" -f $(get-date -date $DisableTime -UFormat "%d-%m-%Y")

$Enableaction = New-ScheduledTaskAction -Execute 'Powershell.exe' -Argument '-nologo -noprofile -noninteractive -command C:\script\MM-24subscriptions\Enable-MM-24h-Subscriptions.ps1'
$Disableaction = New-ScheduledTaskAction -Execute 'Powershell.exe' -Argument '-nologo -noprofile -noninteractive -command C:\script\MM-24subscriptions\Disable-MM-24h-Subscriptions.ps1'

$Enabletrigger =  New-ScheduledTaskTrigger -Once -At $EnableTime
$Disabletrigger =  New-ScheduledTaskTrigger -Once -At $DisableTime


$settings = New-ScheduledTaskSettingsSet -MultipleInstances Parallel
$principal = New-ScheduledTaskPrincipal -UserID "NT AUTHORITY\SYSTEM" -LogonType ServiceAccount -RunLevel Highest
#$principal = New-ScheduledTaskPrincipal -LogonType S4U

Register-ScheduledTask -Action $Enableaction -Trigger $Enabletrigger -TaskName $enableTaskName -Description "Enable MM 24h Subscriptions" -Principal $principal
Register-ScheduledTask -Action $Disableaction -Trigger $Disabletrigger -TaskName $DisableTaskName -Description "Disable MM 24h Subscriptions" -Principal $principal



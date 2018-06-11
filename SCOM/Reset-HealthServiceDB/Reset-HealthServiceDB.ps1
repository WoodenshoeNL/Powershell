
$healthServiceDB = "$env:programfiles\Microsoft Monitoring Agent\Agent\Health Service State\Health Service Store\HealthServiceStore.edb"

Stop-Service healthservice
Remove-Item $healthServiceDB -Force
Start-Service healthservice
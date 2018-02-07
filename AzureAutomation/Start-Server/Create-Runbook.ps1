
$ResourceGroupName = "Milou"
$Location = "WestEurope"
$AutomationAccount = "Milou-AA"


$RunbookName = "Start-ServerMilou"
$Description = "Start Server van Milou Runbook"

$Script = ".\Start-ServerMilou.ps1"

#New-AzureRmAutomationRunbook -ResourceGroupName $ResourceGroupName -AutomationAccountName $AutomationAccount -RunbookName $RunbookName -Type $RunbookType -Description $Description

Import-AzureRmAutomationRunbook -Path $Script -Name $RunbookName -Type PowerShell -ResourceGroupName $ResourceGroupName -AutomationAccountName $AutomationAccount -Force


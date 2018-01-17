
$ResourceGroupName = "Azure-Test"
$Location = "WestEurope"
$AutomationAccount = "Test-AA"


$RunbookName = "Test-Runbook"
$Description = "Test Hello World Runbook"

$Script = ".\Hello-World.ps1"

#New-AzureRmAutomationRunbook -ResourceGroupName $ResourceGroupName -AutomationAccountName $AutomationAccount -RunbookName $RunbookName -Type $RunbookType -Description $Description

Import-AzureRmAutomationRunbook -Path $Script -Name $RunbookName -Type PowerShell -ResourceGroupName $ResourceGroupName -AutomationAccountName $AutomationAccount -Force



$ResourceGroupName = "Script"
$Location = "WestEurope"
$AutomationAccount = "Script-AA"


$RunbookName = "Show-VMstatus"
$Description = "toont de status van de VM's in een Resource Group"

$Script = ".\Show-VMstatus.ps1"

#New-AzureRmAutomationRunbook -ResourceGroupName $ResourceGroupName -AutomationAccountName $AutomationAccount -RunbookName $RunbookName -Type $RunbookType -Description $Description

Import-AzureRmAutomationRunbook -Path $Script -Name $RunbookName -Type PowerShell -ResourceGroupName $ResourceGroupName -AutomationAccountName $AutomationAccount -Force


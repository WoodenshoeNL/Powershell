
$ResourceGroupName = "Azure-Test"
$Location = "WestEurope"
$AutomationAccount = "Test-AA"

$RunbookName = "Test-Runbook"

Publish-AzureRmAutomationRunbook -Name $RunbookName -ResourceGroupName $ResourceGroupName -AutomationAccountName $AutomationAccount

$ResourceGroupName = "Milou"
$Location = "WestEurope"
$AutomationAccount = "Milou-AA"

$RunbookName = "Start-ServerMilou"

Publish-AzureRmAutomationRunbook -Name $RunbookName -ResourceGroupName $ResourceGroupName -AutomationAccountName $AutomationAccount
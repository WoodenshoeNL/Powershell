$ResourceGroupName = "Milou"
$Location = "WestEurope"
$AutomationAccount = "Milou-AA"

$RunbookName = "Test-Runbook"
$ScheduleName = "Every Friday night"

New-AzureRmAutomationSchedule -Name $ScheduleName -StartTime $($(get-date).AddHours(6)) -DaysOfWeek Friday -WeekInterval 1 -ResourceGroupName $ResourceGroupName -AutomationAccountName $AutomationAccount


Register-AzureRmAutomationScheduledRunbook -RunbookName $RunbookName -ScheduleName $ScheduleName -AutomationAccountName $AutomationAccount -ResourceGroupName $ResourceGroupName


$ResourceGroupName = "Milou"
$Location = "WestEurope"
$AutomationAccount = "Milou-AA"


$RunbookName = "Start-ServerMilou"
$ScheduleName = "dagelijks om 10 uur"


$StartTime = $(Get-Date "10:00:00").adddays(1)
$EndTime = $StartTime.AddYears(3)

New-AzureRmAutomationSchedule -Name $ScheduleName -StartTime $StartTime -ExpiryTime $EndTime -DayInterval 1 -ResourceGroupName $ResourceGroupName -AutomationAccountName $AutomationAccount

Register-AzureRmAutomationScheduledRunbook -RunbookName $RunbookName -ScheduleName $ScheduleName -AutomationAccountName $AutomationAccount -ResourceGroupName $ResourceGroupName



$ResourceGroupName = "Azure-Test"
$Location = "WestEurope"
$AutomationAccount = "Test-AA"

$ConfigName = "testConfig"

Start-AzureRmAutomationDscCompilationJob -ConfigurationName $ConfigName -ResourceGroupName $ResourceGroupName -AutomationAccountName $AutomationAccount
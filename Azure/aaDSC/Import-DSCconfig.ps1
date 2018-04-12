
$ResourceGroupName = "Azure-Test"
$Location = "WestEurope"
$AutomationAccount = "Test-AA"

$ConfigSource = "C:\GIT\Powershell\Azure\aaDSC\testConfig.ps1"

Import-AzureRmAutomationDscConfiguration -AutomationAccountName $AutomationAccount -ResourceGroupName $ResourceGroupName -SourcePath $ConfigSource -Force -Published
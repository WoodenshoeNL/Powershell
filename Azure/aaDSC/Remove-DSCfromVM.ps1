$ResourceGroupName = "Azure-Test"
$Location = "WestEurope"
$AutomationAccount = "Test-AA"

$ConfigName = "testConfig"

$VMname = "VM-Container001"
$NodeConfig = "testConfig.NotWebServer"


$node = Get-AzureRmAutomationDscNode -ResourceGroupName $ResourceGroupName -AutomationAccountName $AutomationAccount -Name $VMname

Unregister-AzureRmAutomationDscNode -AutomationAccountName $AutomationAccount -ResourceGroupName $ResourceGroupName -Id $node.Id -Force
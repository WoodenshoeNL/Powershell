
$VMResourceGroupName = "CONTAINERDEMO"
$ResourceGroupName = "Azure-Test"
$Location = "WestEurope"
$AutomationAccount = "Test-AA"

$ConfigName = "testConfig"

$VMname = "VM-Container001"
$NodeConfig = "testConfig.IsWebServer"

Register-AzureRmAutomationDscNode -AzureVMName $VMname `
-NodeConfigurationName $NodeConfig `
-RefreshFrequencyMins "30" -ConfigurationModeFrequencyMins "15" `
-ConfigurationMode ApplyAndMonitor -AllowModuleOverwrite $true `
-RebootNodeIfNeeded $false -ActionAfterReboot ContinueConfiguration `
-AutomationAccountName $AutomationAccount `
-ResourceGroupName $ResourceGroupName `
-AzureVMResourceGroup $VMResourceGroupName
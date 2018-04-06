Register-AzureRmAutomationDscNode -AzureVMName "WebServer" `
    -NodeConfigurationName "TestConfig.WebServer" `
    -RefreshFrequencyMins "30" -ConfigurationModeFrequencyMins "15" `
    -ConfigurationMode ApplyAndMonitor -AllowModuleOverwrite $true `
    -RebootNodeIfNeeded $false -ActionAfterReboot ContinueConfiguration `
    -AutomationAccountName "FabrikamAutomation" `
    -ResourceGroupName "MyAutomationRG"
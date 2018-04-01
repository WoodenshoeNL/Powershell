$rgName     = "Contoso" 
$scriptName = "deploy-ad.ps1"
$scriptUri = http://$storageAccount.blob.core.windows.net/scripts/$scriptName
$scriptArgument = "contoso.com $password"
Set-AzureRmVMCustomScriptExtension -ResourceGroupName $rgName `
                                   -VMName $vmName `
                                   -FileUri $scriptUri `
                                   -Argument "$domain $password" `
                                   -Run $scriptName  
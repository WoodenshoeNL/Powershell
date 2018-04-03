$storageAccount = "[storage account name]"
$resourceGroup = "[resource group name]"
$storageKey = Get-AzureRmStorageAccountKey -ResourceGroupName $resourceGroup `
                                           -StorageAccountName $storageAccount
$context = New-AzureStorageContext -StorageAccountName $storageAccount `
                                      -StorageAccountKey $storageKey.Value[0]
New-AzureStorageContainer -Context $context `
                          -Name "examrefcontainer1" `
                          -Permission Off 
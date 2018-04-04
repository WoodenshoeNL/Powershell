$storageAccount = "[storage account]"
$rgName = "[resource group name]"
$container = "[storage container name]"
$storageKey = Get-AzureRmStorageAccountKey -ResourceGroupName $rgName -Name $storageAccount
$context = New-AzureStorageContext -StorageAccountName $storageAccount `
                                   -StorageAccountKey $storageKey[0].Value
$startTime = Get-Date
$endTime = $startTime.AddHours(4)
New-AzureStorageBlobSASToken -Container $container `
                             -Blob "Workshop List - 2017.xlsx" `
                             -Permission "rwd" `
                             -StartTime $startTime `
                             -ExpiryTime $endTime `
                             -Context $context
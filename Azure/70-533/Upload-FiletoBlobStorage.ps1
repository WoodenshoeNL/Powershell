
$storageAccount = "[storage account name]"
$resourceGroup = "[resource group name]"
$storageKey = Get-AzureRmStorageAccountKey -ResourceGroupName $resourceGroup `
                                           -StorageAccountName $storageAccount
$context = New-AzureStorageContext -StorageAccountName $storageAccount `
                                      -StorageAccountKey $storageKey.Value[0]

$containerName = "[storage account container]"$blobName = "[blob name]" 
$localFileDirectory = "C:\SourceFolder"
$localFile = Join-Path $localFileDirectory $BlobName 
Set-AzureStorageBlobContent -File $localFile `
                            -Container $ContainerName `
                            -Blob $blobName `
                            -Context $context 
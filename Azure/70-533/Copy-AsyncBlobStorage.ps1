$blobName            = "[file name]"
$srcContainer       = "[source container]"
$destContainer      = "[destination container]"
$srcStorageAccount  = "[source storage]"
$destStorageAccount = "[dest storage]"
$sourceRGName       = "[source resource group name]"
$destRGName          = "[destination resource group name]"
$srcStorageKey = Get-AzureRmStorageAccountKey -ResourceGroupName $sourceRGName 
-Name $srcStorageAccount
$destStorageKey = Get-AzureRmStorageAccountKey -ResourceGroupName $destRGName
 -Name $destStorageAccount
$srcContext = New-AzureStorageContext -StorageAccountName $srcStorageAccount `
                                      -StorageAccountKey $srcStorageKey.Value[0]
$destContext = New-AzureStorageContext -StorageAccountName $destStorageAccount `
                                      -StorageAccountKey $destStorageKey.Value[0]
New-AzureStorageContainer -Name $destContainer `
                          -Context $destContext
$copiedBlob = Start-AzureStorageBlobCopy -SrcBlob $blobName `
                                         -SrcContainer $srcContainer `
                                         -Context $srcContext `
                                         -DestContainer $destContainer `
                                         -DestBlob $blobName `
                                         -DestContext $destContext 
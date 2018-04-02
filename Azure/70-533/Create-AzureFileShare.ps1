# Create a storage context to authenticate 
$rgName = "StorageRG"
$storageName = "erstandard01"
$storageKey = (Get-AzureRmStorageAccountKey -ResourceGroupName $rgName -Name $storageName).Value[0]
$storageContext = New-AzureStorageContext $storageAccountName $storageKey
# Create a new storage share 
$shareName = "logs"
$share = New-AzureStorageShare $shareName -Context $storageContext
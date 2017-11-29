

$ResourceGroupName = "Azure-Test"
$Location = "WestEurope"

$sku = "Standard_LRS"

$StorageAccountName = "woodenshoeteststorage01"


New-AzureRmStorageAccount -ResourceGroupName $ResourceGroupName -AccountName $StorageAccountName -Location $Location -SkuName $sku
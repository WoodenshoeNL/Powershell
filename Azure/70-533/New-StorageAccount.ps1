$saName     = "storagew777"
$storageAcc = New-AzureRmStorageAccount -ResourceGroupName $rgName `
                                        -Name $saName `
                                        -Location $location `
                                        -SkuName Standard_LRS
$blobEndpoint = $storageAcc.PrimaryEndpoints.Blob.ToString()
$rgName = "Contoso"
$location = "westus"
$vmName = "DSCVM"
$storageName = "erstorage"
$configurationName = "ContosoWeb"
$archiveBlob = "ContosoWeb.ps1.zip"
$configurationPath = ".\ContosoWeb.ps1"
#Publish the configuration script into Azure storage
Publish-AzureRmVMDscConfiguration -ConfigurationPath $configurationPath `
                                 -ResourceGroupName $rgName `
                                 -StorageAccountName $storageName 
#Set the VM to run the DSC configuration
Set-AzureRmVmDscExtension -Version 2.26 `
                         -ResourceGroupName $resourceGroup `
                     -VMName $vmName `
                      -ArchiveStorageAccountName $storageName `
                      -ArchiveBlobName $archiveBlob `
                      -AutoUpdate:$false `
                           -ConfigurationName $configurationName
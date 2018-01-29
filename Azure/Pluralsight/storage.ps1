break
# #############################################################################
# Azure Storage
# AUTHOR:  Tim Warner
# EMAIL: timothy-warner@pluralsight.com
# TWITTER: @TechTrainerTim
# WEB: timw.info
# #############################################################################
 
# Press CTRL+M to expand/collapse regions

#region Connect to Azure
Login-AzureRmAccount
Select-AzureRmSubscription -SubscriptionName '150-Jan-19'
Get-AzureRmSubscription -SubscriptionName '150-Jan-19' | Set-AzureRmContext
Get-Command -CommandType Alias -Module AzureRM*
Get-AzureRmContext
Set-AzureRmCurrentStorageAccount -ResourceGroupName 'AzureTraining' -Name 'azuretrainingstorage2'
#endregion

#region Copy a blob between storage accounts
$source = Get-AzureRmStorageAccount -ResourceGroupName AzureTraining -Name 'azuretrainingstorage2'
$sourceendpoint = $source.PrimaryEndpoints.Blob
$sourcekey = (Get-AzureRmStorageAccountKey -ResourceGroupName AzureTraining -Name 'azuretrainingstorage2').Value

$dest = Get-AzureRmStorageAccount -ResourceGroupName AzureTraining -Name 'storagetest704'
$destendpoint = $dest.PrimaryEndpoints.Blob
$destkey = (Get-AzureRmStorageAccountKey -ResourceGroupName AzureTraining -Name 'azuretrainingstorage2').Value

azcopy /?

AzCopy /source:<The https:// URL to your storage account and container> 
/Dest:<The https:// URL to your destination storage account and container>
/sourcekey:<The primary key for the source storage account>
/destkey:<The primary key for the target storage account> /pattern:<file name>

# stop and deallocate the source VM first!
AzCopy /source:https://azuretrainingstorage2.blob.core.windows.net/vhds/ /Dest:https://storagetest704.blob.core.windows.net/vhds/ /sourcekey:7INyl9kRUTOIr01vHdj0wcfmGXThZo2oZY9nZji5ivCOdjeEcdL5ejDohQCExR/yWqedymKoJ1xUc3VRZsbezQ== /destkey:7INyl9kRUTOIr01vHdj0wcfmGXThZo2oZY9nZji5ivCOdjeEcdL5ejDohQCExR/yWqedymKoJ1xUc3VRZsbezQ== /pattern:centos70420170106114019.vhd


#endregion

#region Capture a generalized VHD

# sysprep on Windows VMs
# sudo waagent -deprovision+user

Stop-AzureRmVM -ResourceGroupName 'AzureTraining' -Name 'vm-win100' -Force

Set-AzureRmVm -ResourceGroupName 'AzureTraining' -Name 'vm-win100' -Generalized

# save the image
Save-AzureRmVMImage -ResourceGroupName 'AzureTraining' -Name 'vm-win100'  `
   -DestinationContainerName 'images' -VHDNamePrefix 'winimage'  `
   -Path 'C:\vm-win100.json'

ise 'C:\vm-win100.json'

#endregion

#region Create a new VM based on a captured image

# reference: http://timw.info/newvm

  # Enter a new user name and password to use as the local administrator account 
    # for remotely accessing the VM.
    $cred = Get-Credential

    # Name of the storage account where the VHD is located. This example sets the 
    # storage account name as "myStorageAccount"
    $storageAccName = "myStorageAccount"

    # Name of the virtual machine. This example sets the VM name as "myVM".
    $vmName = "myVM"

    # Size of the virtual machine. This example creates "Standard_D2_v2" sized VM. 
    # See the VM sizes documentation for more information: 
    # https://azure.microsoft.com/documentation/articles/virtual-machines-windows-sizes/
    $vmSize = "Standard_D2_v2"

    # Computer name for the VM. This examples sets the computer name as "myComputer".
    $computerName = "myComputer"

    # Name of the disk that holds the OS. This example sets the 
    # OS disk name as "myOsDisk"
    $osDiskName = "myOsDisk"

    # Assign a SKU name. This example sets the SKU name as "Standard_LRS"
    # Valid values for -SkuName are: Standard_LRS - locally redundant storage, Standard_ZRS - zone redundant
    # storage, Standard_GRS - geo redundant storage, Standard_RAGRS - read access geo redundant storage,
    # Premium_LRS - premium locally redundant storage. 
    $skuName = "Standard_LRS"

    # Get the storage account where the uploaded image is stored
    $storageAcc = Get-AzureRmStorageAccount -ResourceGroupName $rgName -AccountName $storageAccName

    # Set the VM name and size
    $vmConfig = New-AzureRmVMConfig -VMName $vmName -VMSize $vmSize

    #Set the Windows operating system configuration and add the NIC
    $vm = Set-AzureRmVMOperatingSystem -VM $vmConfig -Windows -ComputerName $computerName `
        -Credential $cred -ProvisionVMAgent -EnableAutoUpdate
    $vm = Add-AzureRmVMNetworkInterface -VM $vm -Id $nic.Id

    # Create the OS disk URI
    $osDiskUri = '{0}vhds/{1}-{2}.vhd' `
        -f $storageAcc.PrimaryEndpoints.Blob.ToString(), $vmName.ToLower(), $osDiskName
    ##############################################################################################
    ##############################################################################################
    # Configure the OS disk to be created from the existing VHD image (-CreateOption fromImage).
    $vm = Set-AzureRmVMOSDisk -VM $vm -Name $osDiskName -VhdUri $osDiskUri `
        -CreateOption fromImage -SourceImageUri $imageURI -Windows

    # Create the new VM
    New-AzureRmVM -ResourceGroupName $rgName -Location $location -VM $vm

#endregion

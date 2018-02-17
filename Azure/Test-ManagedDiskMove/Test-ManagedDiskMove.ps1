
Write-Host "[^] Script Start - $(Get-Date)" -ForegroundColor "Darkgreen"
#####Set Variable
$VMname = "VM-DiskTest001"
$snapshotName = "ManagedDiskSnapshot_$VMname"
$virtualMachineSize = "Standard_D2s_v3"

$resourceGroupName = "TestManagedDisk"
$resourceGroupName2 = "TestManagedDisk2"
$NetworkresourceGroupName = "Azure-Test"
$BootDiagResourceGroupName = "testserver"
$BootDiagAccount = "azuretestdiag001"
$virtualNetworkName = "VNet01"
$NetworkSecurityGroup = "Test-NSG"
$NetworkSecurityGroupRG = "Azure-Test"

$Location = "westeurope"
$storageType = "PremiumLRS"

$templateFilePath = "template.json"
$parametersFilePath = "parameters.json"
$ErrorActionPreference = "Stop"

#Login-AzureRmAccount;
#####Create Resource Groups
Write-Host "[->] Create ResourceGroups" -ForegroundColor "DarkGreen"
New-AzureRmResourceGroup -Name $resourceGroupName -Location $Location
New-AzureRmResourceGroup -Name $resourceGroupName2 -Location $Location

#####Deploy Test Server
Write-Host "[->] Start Deployment" -ForegroundColor "DarkGreen"
New-AzureRmResourceGroupDeployment -ResourceGroupName $resourceGroupName -TemplateFile $templateFilePath -TemplateParameterFile $parametersFilePath -Verbose;
Write-Host "[->] Deployment Compleet - $(Get-Date)" -ForegroundColor "DarkGreen"

#####Stop VM
Write-Host "[->] Stop VM - $vmname" -ForegroundColor "DarkGreen"
Stop-AzureRmVM -ResourceGroupName $resourceGroupName -Name $VMname -Force

#####Create managed disks snapshots
Write-Host "[->] Create Snapshot" -ForegroundColor "DarkGreen"
$VM = Get-AzureRmVM -ResourceGroupName $resourceGroupName -Name $VMname
$disk = Get-AzureRmDisk -ResourceGroupName $resourceGroupName | Where-Object{$_.ManagedBy -eq $VM.Id}
$snapshotConfig =  New-AzureRmSnapshotConfig -SourceUri $disk.Id -CreateOption Copy -Location $location -AccountType $storageType
$snapshot = New-AzureRmSnapshot -Snapshot $snapshotConfig -SnapshotName $snapshotName -ResourceGroupName $resourceGroupName

#####Get IP & DNS
Write-Host "[->] Get IP" -ForegroundColor "DarkGreen"
$nics = get-azurermnetworkinterface
foreach($nic in $nics)
{
    if($nic.virtualmachine.Id -match $VMname){
        $IPaddress =  $nic.IpConfigurations | select-object -ExpandProperty PrivateIpAddress
        $DNSservers = $nic.DnsSettings | select-object -ExpandProperty DnsServers
        $nic2 = $nic
    }
}  
Write-Host "[==] IP = $IPaddress" -ForegroundColor "DarkGreen"

#####Delete VM
Write-Host "[->] Remove VM" -ForegroundColor "DarkGreen"
Remove-AzureRmVM -ResourceGroupName $resourceGroupName -Name $VMname -Force
#Get-AzureRmDisk -ResourceGroupName $resourceGroupName | Where-Object{$_.ManagedBy -eq $VM.Id} | Remove-AzureRmDisk
Remove-AzureRmNetworkInterface -ResourceGroupName $resourceGroupName -Name $nic2.Name -Force

#####Create new managed disks from snapshots in the new Resource Group
#$snapshot = Get-AzureRmSnapshot -ResourceGroupName $resourceGroupName -SnapshotName $snapshotName 
Write-Host "[->] Create Managed Disk in Resource Group: $resourceGroupName2" -ForegroundColor "DarkGreen"
$osDiskName = $disk.name
$diskConfig = New-AzureRmDiskConfig -AccountType $storageType -Location $snapshot.Location -SourceResourceId $snapshot.Id -CreateOption Copy
$disk = New-AzureRmDisk -Disk $diskConfig -ResourceGroupName $resourceGroupName2 -DiskName $osDiskName

#####Deploy new vm using using managed disks in the new Resource Group
$virtualMachineName = $VMname.ToString()
Write-Host "[->] Create VM($virtualMachineName) in Resource Group: $resourceGroupName2" -ForegroundColor "DarkGreen"
$VirtualMachine = New-AzureRmVMConfig -VMName $virtualMachineName -VMSize $($virtualMachineSize).ToString()
$VirtualMachine = Set-AzureRmVMOSDisk -VM $VirtualMachine -ManagedDiskId $disk.Id -CreateOption Attach -Windows
$vnet = Get-AzureRmVirtualNetwork -Name $virtualNetworkName -ResourceGroupName $NetworkresourceGroupName
$NSG = Get-AzureRmNetworkSecurityGroup -Name  $NetworkSecurityGroup -ResourceGroupName $NetworkSecurityGroupRG
$nic = New-AzureRmNetworkInterface -Name ($VirtualMachineName.ToLower()+'_nic') -ResourceGroupName $resourceGroupName2 -Location $snapshot.Location -SubnetId $vnet.Subnets[0].Id -NetworkSecurityGroupId $NSG.id -PrivateIpAddress $IPaddress -DnsServer $DNSservers
$VirtualMachine = Add-AzureRmVMNetworkInterface -VM $VirtualMachine -Id $nic.Id
Set-AzureRmVMBootDiagnostics -vm $VirtualMachine -Enable -ResourceGroupName $BootDiagResourceGroupName -StorageAccountName $BootDiagAccount
New-AzureRmVM -VM $VirtualMachine -ResourceGroupName $resourceGroupName2 -Location $snapshot.Location

Write-Host "[$] Script Finished - $(Get-Date)" -ForegroundColor "Darkgreen"




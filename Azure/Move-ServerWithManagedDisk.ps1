
Write-Host "[^] Script Start - $(Get-Date)" -ForegroundColor "Darkgreen"
#####Set Variable
$VMname = "VM-1"
$snapshotName = "ManagedDiskSnapshot_$VMname"
$virtualMachineSize = "Standard_DS2_v2"

$resourceGroupName = "RG-T"
$resourceGroupName2 = "RG-V-T"
#$NetworkresourceGroupName = "Expressroute-CloudConnect"
$BootDiagResourceGroupName = "RG-T"
$BootDiagAccount = "diagstorageaccount"
#$virtualNetworkName = "VWInfraAzureNetwork"
$NetworkSecurityGroup = "NSG-T"
$NetworkSecurityGroupRG = "RG-T"
$subnetID = "/subscriptions/<subscriptionID>/resourceGroups/Expressroute-CloudConnect/providers/Microsoft.Network/virtualNetworks/<VNET>/subnets/<SubnetName>"

$Location = "westeurope"
$storageType = "PremiumLRS"
#$ErrorActionPreference = "Stop"
$MultiDisk = $false

#Login-AzureRmAccount;

#####Stop VM
Write-Host "[->] Stop VM - $vmname" -ForegroundColor "DarkGreen"
Stop-AzureRmVM -ResourceGroupName $resourceGroupName -Name $VMname -Force

#####Create managed disks snapshots
Write-Host "[->] Create Snapshot" -ForegroundColor "DarkGreen"
$VM = Get-AzureRmVM -ResourceGroupName $resourceGroupName -Name $VMname
$disk = Get-AzureRmDisk -ResourceGroupName $resourceGroupName | Where-Object{$_.ManagedBy -eq $VM.Id}
if ($disk.gettype().basetype.name -eq "Array"){
    $i = 0
    foreach($d in $disk){
        $snapshotConfig =  New-AzureRmSnapshotConfig -SourceUri $d.Id -CreateOption Copy -Location $location -AccountType $storageType
        $snapshot = New-AzureRmSnapshot -Snapshot $snapshotConfig -SnapshotName "$snapshotName-$i" -ResourceGroupName $resourceGroupName
        $i++
    }
    $MultiDisk = $true
}
else {
    $snapshotConfig =  New-AzureRmSnapshotConfig -SourceUri $disk.Id -CreateOption Copy -Location $location -AccountType $storageType
    $snapshot = New-AzureRmSnapshot -Snapshot $snapshotConfig -SnapshotName $snapshotName -ResourceGroupName $resourceGroupName
}


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
#>
#####Create new managed disks from snapshots in the new Resource Group
#$snapshot = Get-AzureRmSnapshot -ResourceGroupName $resourceGroupName -SnapshotName $snapshotName 
Write-Host "[->] Create Managed Disk in Resource Group: $resourceGroupName2" -ForegroundColor "DarkGreen"
if($MultiDisk -eq $false){
    $osDiskName = $disk.name
    $diskConfig = New-AzureRmDiskConfig -AccountType $storageType -Location $snapshot.Location -SourceResourceId $snapshot.Id -CreateOption Copy
    $disk = New-AzureRmDisk -Disk $diskConfig -ResourceGroupName $resourceGroupName2 -DiskName $osDiskName
}
else {
    $snapshot = Get-AzureRmSnapshot -ResourceGroupName $resourceGroupName -SnapshotName "$snapshotName-0"
    $osDiskName = $disk[0].name
    $diskConfig = New-AzureRmDiskConfig -AccountType $storageType -Location $snapshot.Location -SourceResourceId $snapshot.Id -CreateOption Copy
    $disk0 = New-AzureRmDisk -Disk $diskConfig -ResourceGroupName $resourceGroupName2 -DiskName $osDiskName
    $snapshot = Get-AzureRmSnapshot -ResourceGroupName $resourceGroupName -SnapshotName "$snapshotName-1"
    $DataDiskName = $disk[1].name
    $diskConfig = New-AzureRmDiskConfig -AccountType $storageType -Location $snapshot.Location -SourceResourceId $snapshot.Id -CreateOption Copy
    $disk1 = New-AzureRmDisk -Disk $diskConfig -ResourceGroupName $resourceGroupName2 -DiskName $DataDiskName
}


#####Deploy new vm using using managed disks in the new Resource Group
$virtualMachineName = $VMname.ToString()
Write-Host "[->] Create VM($virtualMachineName) in Resource Group: $resourceGroupName2" -ForegroundColor "DarkGreen"
$VirtualMachine = New-AzureRmVMConfig -VMName $virtualMachineName -VMSize $($virtualMachineSize).ToString()
if($MultiDisk -eq $false){
    $VirtualMachine = Set-AzureRmVMOSDisk -VM $VirtualMachine -ManagedDiskId $disk.Id -CreateOption Attach -Windows
}
else{
    $VirtualMachine = Set-AzureRmVMOSDisk -VM $VirtualMachine -ManagedDiskId $disk0.Id -CreateOption Attach -Windows
}
#$vnet = Get-AzureRmVirtualNetwork -Name $virtualNetworkName -ResourceGroupName $NetworkresourceGroupName
$NSG = Get-AzureRmNetworkSecurityGroup -Name  $NetworkSecurityGroup -ResourceGroupName $NetworkSecurityGroupRG
$nic = New-AzureRmNetworkInterface -Name ($VirtualMachineName.ToLower()+'777') -ResourceGroupName $resourceGroupName2 -Location $snapshot.Location -SubnetId $subnetID -NetworkSecurityGroupId $NSG.id -PrivateIpAddress $IPaddress -DnsServer $DNSservers
$VirtualMachine = Add-AzureRmVMNetworkInterface -VM $VirtualMachine -Id $nic.Id
Set-AzureRmVMBootDiagnostics -vm $VirtualMachine -Enable -ResourceGroupName $BootDiagResourceGroupName -StorageAccountName $BootDiagAccount
New-AzureRmVM -VM $VirtualMachine -ResourceGroupName $resourceGroupName2 -Location $snapshot.Location

if($MultiDisk -eq $true){
    Write-Host "[->] Add Data Disk Lun 1" -ForegroundColor "DarkGreen"
    $vm = Get-AzureRmVM -Name $virtualMachineName -ResourceGroupName $resourceGroupName2 
    $vm = Add-AzureRmVMDataDisk -VM $vm -Name $DataDiskName -CreateOption Attach -ManagedDiskId $disk1.Id -Lun 1
    Update-AzureRmVM -VM $vm -ResourceGroupName $resourceGroupName2 
}


Write-Host "[$] Script Finished - $(Get-Date)" -ForegroundColor "Darkgreen"
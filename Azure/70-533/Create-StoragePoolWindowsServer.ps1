

# Create a new storage pool using all available disks 
New-StoragePool -FriendlyName "VMStoragePool" `
          -StorageSubsystemFriendlyName "Windows Storage*" `
          -PhysicalDisks (Get-PhysicalDisk -CanPool $True)
# Return all disks in the new pool
$disks = Get-StoragePool -FriendlyName "VMStoragePool" `
               -IsPrimordial $false | 
               Get-PhysicalDisk
# Create a new virtual disk 
New-VirtualDisk -FriendlyName "DataDisk" `
          -ResiliencySettingName Simple `
          -NumberOfColumns $disks.Count `
          -UseMaximumSize -Interleave 256KB `
          -StoragePoolFriendlyName "VMStoragePool" 
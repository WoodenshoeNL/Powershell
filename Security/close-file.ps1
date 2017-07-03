
Param(
  [string]$file
)

$groep1 = "Domain\Beheerders"
$groep2 = "Domain\Engineers"


#$file = "c:\temp\test.txt"


#file sluiten

& "c:\Program Files\Unlocker\Unlocker.exe" $file /s /o


#inheritance uitzetten file

$acl = Get-ACL -Path $file
$acl.SetAccessRuleProtection($True, $True)
Set-Acl -Path $file -AclObject $acl

$acl | fl
#rechten groep 1

$acl = Get-ACL -Path $file

$permission = $groep1,"ReadAndExecute","Allow"
$accessRule = new-object System.Security.AccessControl.FileSystemAccessRule $permission

$acl.AddAccessRule($AccessRule)
Set-Acl $file $acl

#rechten groep 2

$acl = Get-ACL -Path $file

$permission = $groep2,"Modify","Allow"
$accessRule = new-object System.Security.AccessControl.FileSystemAccessRule $permission
$acl.AddAccessRule($AccessRule)


Set-Acl $file $acl

$acl | fl
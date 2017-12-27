
. .\Set-Owner.ps1

$scandir = "c:\test"

$dirPattern = "downloads$"

$user = "test\testadmin"
$UserPermissions = "FullControl"   #Opties: "Modify" , "ReadAndExecute" , "FullControl"

Write-Host "Start Script"
Write-Host "Get All ChildItems from: $scandir"
foreach ($dir in $(Get-ChildItem -Recurse -Path $scandir -Directory)){
    if ($dir -match $dirPattern){
        Write-Host "[*]  Download Folder found: $($dir.fullname) " -ForegroundColor "green"
        $acl = $dir.GetAccessControl()
        $previousOwner = $acl.Owner
        Write-Host "[->] Previous Owner = $previousOwner" -ForegroundColor "DarkYellow"
        Write-Host "[+]  Changing Owner to $user" -ForegroundColor "DarkBlue"
        Set-Owner -Path $dir.fullname -Account $user -Recurse

        Write-Host "[+]  Changing ACL > $UserPermissions for $user"  -ForegroundColor "DarkBlue"
        Write-host "[++] Create ACL" -ForegroundColor "DarkMagenta"
        $acl = Get-ACL -Path $dir.fullname
        $permission = $user, $UserPermissions, 'ContainerInherit,ObjectInherit', 'None', 'Allow'
        $accessRule = new-object System.Security.AccessControl.FileSystemAccessRule $permission
        $acl.AddAccessRule($AccessRule)
        Write-Verbose $acl | Format-List
        Write-host "[++] Set ACL" -ForegroundColor "DarkMagenta"
        Set-Acl $dir.fullname $acl

        Start-Sleep 1

        Write-Host "[+]  Changing Owner to $previousOwner" -ForegroundColor "Yellow"
        Set-Owner -Path $dir.fullname -Account $previousOwner -Recurse

        Write-Host "[$] Folder: $($dir.fullname) Done..." -ForegroundColor "Blue"
        Write-Host

        Start-Sleep 1

    }

}


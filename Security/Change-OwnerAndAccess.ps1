
. .\Set-Owner.ps1

$scandir = "c:\test"

$dirPattern = "downloads$"

$user = "test\testadmin"
$aclUser = "test\testadmin"
$UserPermissions = "FullControl"   #Opties: "Modify" , "ReadAndExecute" , "FullControl"

Write-Host "Start Script"
Write-Host "Get All ChildItems from: $scandir"
foreach ($dir in $(Get-ChildItem -Recurse -Path $scandir -Directory)){
    if ($dir -match $dirPattern){
        
        $dir.FullName
        
        $previousOwner = "$($($($dir.FullName).ToString()).split("\")[3])"
        $previousOwnerAAA = "AAA\$($($($dir.FullName).ToString()).split("\")[3])"

        $acl = $dir.GetAccessControl()
        #$previousOwner = $acl.Owner
        Write-Host "[*]  Download Folder found: $($dir.fullname) " -ForegroundColor "green"
        Write-Host "[->] Previous Owner = $previousOwner" -ForegroundColor "DarkYellow"
        Write-Host "[+]  Changing Owner to $user" -ForegroundColor "DarkYellow"
        Set-Owner -Path $dir.fullname -Account $user #-Recurse

        try
            {
            Write-Host "[+]  Changing ACL > $UserPermissions for $aclUser"  -ForegroundColor "DarkYellow"
            Write-host "[++] Create ACL" -ForegroundColor "DarkYellow"
            $acl = Get-ACL -Path $dir.fullname
            $permission = $aclUser, $UserPermissions, 'ContainerInherit,ObjectInherit', 'None', 'Allow'
            $accessRule = new-object System.Security.AccessControl.FileSystemAccessRule $permission
            $null = $acl.AddAccessRule($AccessRule)
            Write-Verbose $acl | Format-List
            Write-host "[++] Set ACL" -ForegroundColor "DarkYellow"
            Set-Acl $dir.fullname $acl

            $acl = Get-ACL -Path $dir.fullname
            $permission = $previousOwnerAAA, $UserPermissions, 'ContainerInherit,ObjectInherit', 'None', 'Allow'
            $accessRule = new-object System.Security.AccessControl.FileSystemAccessRule $permission
            $null = $acl.AddAccessRule($AccessRule)
            Write-Verbose $acl | Format-List
            Write-host "[++] Set ACL" -ForegroundColor "DarkYellow"
            Set-Acl $dir.fullname $acl
        }
        catch [Exception]
        {
            #
            #get-date
        }

        start-sleep 1

        foreach ($dir2 in $(Get-ChildItem -Recurse -Path $dir.FullName)){
            $dir2.FullName
            get-acl $dir2.fullname
            Set-Owner -Path $dir2.fullname -Account $user -Recurse
            try
            {
                Write-Host "[+]  Changing ACL > $UserPermissions for $aclUser"  -ForegroundColor "DarkYellow"
                Write-host "[++] Create ACL" -ForegroundColor "DarkMagenta"
                $acl = Get-ACL -Path $dir2.fullname
                $permission = $aclUser, $UserPermissions, 'ContainerInherit,ObjectInherit', 'None', 'Allow'
                $accessRule = new-object System.Security.AccessControl.FileSystemAccessRule $permission
                $null = $acl.AddAccessRule($AccessRule) |Out-Null
                Write-Verbose $acl | Format-List
                Write-host "[++] Set ACL" -ForegroundColor "DarkYellow"
                Set-Acl $dir2.fullname $acl

                $acl = Get-ACL -Path $dir2.fullname
                $permission = $previousOwnerAAA, $UserPermissions, 'ContainerInherit,ObjectInherit', 'None', 'Allow'
                $accessRule = new-object System.Security.AccessControl.FileSystemAccessRule $permission
                $null = $acl.AddAccessRule($AccessRule) |Out-Null
                Set-Acl $dir2.fullname $acl
                               
                Write-Host "[+]  Changing Owner to $previousOwner" -ForegroundColor "Yellow"
                Set-Owner -Path $dir2.fullname -Account $previousOwner
                get-acl $dir2.fullname
            }
            catch [Exception]
            {
                #
                #get-date
            }
        }
        try
        {
            Write-Host "[+]  Changing Owner to $previousOwner" -ForegroundColor "Yellow"
            Set-Owner -Path $dir.fullname -Account $previousOwner #-Recurse

            Write-Host "[$] Folder: $($dir.fullname) Done..." -ForegroundColor "DarkYellow"
        }
        catch [Exception]
        {
            #
        }
        #>
    }

}


$environment = "TST"

#Groups
$Gis_Operator = "Domain\GG_app-abc-{0}-Operators" -f $environment
$Gis_Users = "SG\GG_app-abc-{0}-Users" -f $environment

#Permissions
$Read = "ReadData"
$Execute = "ReadAndExecute"
$Modify = "Modify"
$Full = "FullControl"

#inheritance
$FullInherit = "ContainerInherit,ObjectInherit"         #This folder, subfolders and files    - $PropagationFlags = "None"
$FolderAndSubfolder = "ContainerInherit"                #This folder, subfolders              - $PropagationFlags = "None"
$Folderonly = "None"                                    #This folder only                     - $PropagationFlags = "None"
$FolderAndFiles = "ObjectInherit"                       #This folder and Files                - $PropagationFlags = "None"
$FilesOnly = "ObjectInherit"                            #This files only                      - $PropagationFlags = "InheritOnly"

function Set-Permission {
    param (
        $User,
        $Permission,
        $Path,
        $right = "Allow",
        $InheritanceFlags = "ContainerInherit,ObjectInherit",
        $PropagationFlags = "None"

    )
    #Check Directory
    if ($(Test-Path -Path $Path) -eq $false){
        Write-Host "Path do not exsist: $Path - Skip path" -ForegroundColor "Red" -BackgroundColor "White"
        return
    }
    #Set ACL
    $acl = Get-Acl -Path $Path
    $AccessRule = New-Object system.security.accesscontrol.filesystemaccessrule($User,$Permission, $InheritanceFlags, $PropagationFlags, $right)
    $Acl.SetAccessRule($AccessRule)
    Set-Acl -path $Path -AclObject $Acl
    Write-Host "Set Permissions | Path: $Path | User: $User | Permission: $Permission"
}


###############
Write-Host "Start Setting Permissions" -ForegroundColor "Green"
###############

Write-Host "Permissions - Block A" -ForegroundColor "Yellow"

Set-Permission -Path "C:\test\folder-A" -User $Gis_Operator -Permission $Modify
Set-Permission -Path "C:\test\E" -User $Gis_Operator -Permission $Modify
Set-Permission -Path "C:\test\folder-A" -User $Gis_Users -Permission $Execute



Write-Host "Permissions - Block B" -ForegroundColor "Yellow"

Set-Permission -Path "C:\test\B" -User $Gis_Operator -Permission $Modify
Set-Permission -Path "C:\test\B" -User $Gis_Users -Permission $Read
Set-Permission -Path "C:\test\B\2\z" -User $Gis_Users -Permission $Modify

###############
Write-Host "Finish Setting Permissions" -ForegroundColor "Green"
###############

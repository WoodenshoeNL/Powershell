
$passwordlist = ".\password.txt"
$users = Get-Content -Path .\userlist.txt

$userOU = "OU=Hybrid,OU=Service Accounts,OU=abc,DC=cc,DC=xyz,DC=nl"

function Generate-Password {
    param (
        $Length = 20
    )
    $password = ""
    $seed = "abcdefghiklmnoprstuvwxyzABCDEFGHKLMNOPRSTUVWXYZ1234567890!|<>^$%&/()=?}][{@#*+"
    foreach($i in 1..$Length){
        $password += $seed[$(Get-random -Maximum $seed.Length)]
    }
    return $password
}



foreach( $user in $users){
    $user
    $password = $(Generate-Password)
    Add-Content -Path $passwordlist -Value $("{0};{1}" -f $user, $password.ToString())
    New-ADUser -Name $user -SamAccountName $user -path $userOU -UserPrincipalName $("{0}@cc.xyz.nl" -f $user) -DisplayName $user
    sleep 5
    $dn = "CN={0},{1}" -f $user, $userOU
    Set-ADAccountPassword -Identity $dn -Reset -NewPassword (ConvertTo-SecureString -AsPlainText $password -Force)
    Set-ADUser -Identity $dn -Enabled $true -PasswordNeverExpires $true
}

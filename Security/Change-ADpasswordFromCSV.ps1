Import-Module ActiveDirectory

$csvFile = ".\users.csv"
$Password = "P@ssw0rd"


$users = Import-Csv -Path $csvFile

foreach ($user in $users)
{
    $user.User
    Set-ADAccountPassword $user.User -Reset -NewPassword (ConvertTo-SecureString -AsPlainText $Password -Force)
}
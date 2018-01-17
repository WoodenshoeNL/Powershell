

$ResourceGroupName = "Milou"
$Location = "WestEurope"

$keyVaultName = "MilouKeyVault"

$testUser = "admmilou"
$testPassword = "9fA884xBBv8Uw7oC7Fmz"



$keyPassword = ConvertTo-SecureString -String $testPassword -AsPlainText -Force

Set-AzureKeyVaultSecret -VaultName $keyVaultName -Name $testUser -SecretValue $keyPassword


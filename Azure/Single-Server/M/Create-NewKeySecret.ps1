

$ResourceGroupName = "Azure-Test"
$Location = "WestEurope"

$keyVaultName = "ScriptKeyVault"

$testUser = "admmilou"
$testPassword = "9fA884xBBv8Uw7oC7Fmz"



$keyPassword = ConvertTo-SecureString -String $testPassword -AsPlainText -Force

Set-AzureKeyVaultSecret -VaultName $keyVaultName -Name $testUser -SecretValue $keyPassword


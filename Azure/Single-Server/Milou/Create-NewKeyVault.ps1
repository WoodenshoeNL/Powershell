

$ResourceGroupName = "Milou"
$Location = "WestEurope"

$keyVaultName = "MilouKeyVault"

$testUser = "admmilou"
$testPassword = "Qt8XBjtA6HfQyBtuM8pz"


New-AzureRmKeyVault -VaultName $keyVaultName -ResourceGroupName $ResourceGroupName -Location $Location -EnabledForTemplateDeployment

$keyPassword = ConvertTo-SecureString -String $testPassword -AsPlainText -Force

Set-AzureKeyVaultSecret -VaultName $keyVaultName -Name $testUser -SecretValue $keyPassword


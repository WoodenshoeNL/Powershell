

$ResourceGroupName = "lab1"
$Location = "WestEurope"

$keyVaultName = "CitadelKeyVault"

$testUser = "ubuntuDefaultPassword"
$testPassword = "fe8FtvWePHUD674EikLw"


New-AzureRmKeyVault -VaultName $keyVaultName -ResourceGroupName $ResourceGroupName -Location $Location -EnabledForTemplateDeployment

$keyPassword = ConvertTo-SecureString -String $testPassword -AsPlainText -Force

Set-AzureKeyVaultSecret -VaultName $keyVaultName -Name $testUser -SecretValue $keyPassword


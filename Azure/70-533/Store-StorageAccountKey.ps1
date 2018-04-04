$vaultName = "[key vault name]"
$rgName = "[resource group name]" 
$location = "[location]"
$keyName = "[key name]" 
$secretName = "[secret name]"
$storageAccount = "[storage account]" 
# create the key vault 
New-AzureRmKeyVault -VaultName $vaultName -ResourceGroupName $rgName -Location $location
# create a software managed key
$key = Add-AzureKeyVaultKey -VaultName $vaultName -Name $keyName -Destination 'Software'
# retrieve the storage account key (the secret) 
$storageKey = Get-AzureRmStorageAccountKey -ResourceGroupName $rgName -Name $storageAccount 

# convert the secret to a secure string
$secretvalue = ConvertTo-SecureString $storageKey[0].Value -AsPlainText -Force

# set the secret value 
$secret = Set-AzureKeyVaultSecret -VaultName $vaultName -Name $secretName -SecretValue $secretvalue 

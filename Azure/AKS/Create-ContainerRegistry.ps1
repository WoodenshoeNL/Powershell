

#Login-AzureRmAccount

$resourceGroup = "ContainerTest"
$RegistryName = "Woodenshoe"

#Create Registry
$registry = New-AzureRMContainerRegistry -ResourceGroupName $resourceGroup -Name $RegistryName -EnableAdminUser -Sku Basic

#Login Registry
$creds = Get-AzureRmContainerRegistryCredential -Registry $registry
docker login $registry.LoginServer -u $creds.Username -p $creds.Password
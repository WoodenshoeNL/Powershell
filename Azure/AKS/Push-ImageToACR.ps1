

$resourceGroup = "ContainerTest"
$RegistryName = "Woodenshoe"


#Login Registry
$registry = Get-AzureRmContainerRegistry -ResourceGroupName $resourceGroup -Name $RegistryName
$creds = Get-AzureRmContainerRegistryCredential -RegistryName $RegistryName -ResourceGroupName $resourceGroup
docker login $registry.LoginServer -u $creds.Username -p $creds.Password


#pull Image
docker pull microsoft/aci-helloworld

#Tag Image
$image = $registry.LoginServer + "/aci-helloworld:v1"
docker tag microsoft/aci-helloworld $image

#Push Image to ACR
docker push $image
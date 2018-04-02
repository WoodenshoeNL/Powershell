
$ResourceGroup = "ContainerTest"
$RegistryName = "ContainerTestReg"
$ContainerName = "TestHelloWorld"

#Login-AzureRmAccount
New-AzureRmResourceGroup -Name $ResourceGroup -Location westeurope


#Create Registry - ACR

$registry = New-AzureRMContainerRegistry -ResourceGroupName $ResourceGroup -Name $RegistryName -EnableAdminUser -Sku Basic

#Get Login Creds ACR
$creds = Get-AzureRmContainerRegistryCredential -Registry $registry

#Docker Login ACR
docker login $registry.LoginServer -u $creds.Username -p $creds.Password


#Pull Image and Push to ACR

docker pull microsoft/aci-helloworld

$image = $registry.LoginServer + "/aci-helloworld:v1"
docker tag microsoft/aci-helloworld $image

docker push $image

#Deploy Image to ACI 

$secpasswd = ConvertTo-SecureString $creds.Password -AsPlainText -Force
$pscred = New-Object System.Management.Automation.PSCredential($creds.Username, $secpasswd)

New-AzureRmContainerGroup -ResourceGroup $ResourceGroup -Name $ContainerName -Image $image -Cpu 1 -MemoryInGB 1 -IpAddressType public -Port 80 -RegistryCredential $pscred

(Get-AzureRmContainerGroup -ResourceGroupName $ResourceGroup -Name $ContainerName).ProvisioningState
(Get-AzureRmContainerGroup -ResourceGroupName $ResourceGroup -Name $ContainerName).IpAddress

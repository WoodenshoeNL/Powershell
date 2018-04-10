
az login

az acs create --orchestrator-type kubernetes --resource-group ContainerTest --name WoodenshoeK8sCluster --generate-ssh-keys --agent-count 1

az acs kubernetes install-cli

az acs kubernetes get-credentials --resource-group=ContainerTest --name=WoodenshoeK8sCluster

kubectl get nodes

az acr list --resource-group ContainerTest --query "[].{acrLoginServer:loginServer}" --output table

docker push woodenshoe.azurecr.io/iis:v1

#az acs kubernetes get-credentials -n WoodenshoeK8sCluster -g ContainerTest --ssh-key-file <name of private key file>
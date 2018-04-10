
az login

az acs create --orchestrator-type kubernetes --resource-group ContainersTest --name WoodenshoeK8sCluster --generate-ssh-keys --agent-count 1

az acs kubernetes install-cli

az acs kubernetes get-credentials --resource-group=ContainersTest --name=WoodenshoeK8sCluster

kubectl get nodes

az acr list --resource-group ContainersTest --query "[].{acrLoginServer:loginServer}" --output table

docker push woodenshoe.azurecr.io/iis:v1

#az acs kubernetes get-credentials -n WoodenshoeK8sCluster -g ContainersTest --ssh-key-file <name of private key file>
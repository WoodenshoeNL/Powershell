$rg="lab1"
$template="C:\GIT\Powershell\Azure\Citadel\azuredeploy.json"
$job="job2"
$storageAccount="citadeltestsa2"
New-AzureRmResourceGroupDeployment -Name $job -storageAccount $storageAccount -TemplateFile $template -ResourceGroupName $rg
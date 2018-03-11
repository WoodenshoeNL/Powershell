$resourceGroupName = "WebApp"
$appServicePlanName = "WebAppPlan"
$location = "WestEurope"
$tier = "Premium"
$workerSize = "small"

New-AzureRmResourceGroup -Name $resourceGroupName -Location $location

New-AzureRmAppServicePlan -ResourceGroupName $resourceGroupName -Name $appServicePlanName -Location $location -Tier $tier -WorkerSize $workerSize 
$resourceGroupName = "WebApp"
$appServicePlanName = "WebAppPlan"
$location = "WestEurope"
$webAppName = "WebApp"

New-AzureRmWebApp -ResourceGroupName $resourceGroupName -Location $location `
 -AppServicePlan $appServicePlanName -Name $webAppName
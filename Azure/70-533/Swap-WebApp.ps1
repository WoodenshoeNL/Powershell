$resourceGroupName = "WebApp"
$location = "WestEurope"
$webAppName = "woodenshoe-test-web-app"
$stagingSlotName = "Dev"
$productionSlotName = "Production" 

$resourceGroupName = "contoso"
$webAppName = "contoso-hr-app"
$stagingSlotName = "Staging"
$productionSlotName = "Production"

# Swap staging and production deployment slots (single phase)
Swap-AzureRmWebAppSlot -ResourceGroupName $resourceGroupName -Name $webAppName `
    -SourceSlotName $stagingSlotName -DestinationSlotName $productionSlotName 
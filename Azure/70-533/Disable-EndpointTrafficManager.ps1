$resourceGroupName = "WebApp"
$tmName = "Woodenshoe-public"
$newTmEndpointName = "Woodenshoe-Web-1"

# Get the current traffic manager profile
$tmProfile = Get-AzureRmTrafficManagerProfile -ResourceGroupName $resourceGroupName -Name $tmName 

Disable-AzureRmTrafficManagerEndpoint -ResourceGroupName $resourceGroupName -ProfileName $tmProfile.Name `
    -Name $newTmEndpointName -Type AzureEndpoints -Force 

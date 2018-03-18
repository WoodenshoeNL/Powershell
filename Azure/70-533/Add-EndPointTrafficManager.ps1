$resourceGroupName = "WebApp"
$webAppName = "Woodenshoe-WebApp"
$newTmEndpointName = "Woodenshoe-Web-1"
$newTmEndpointTarget = "Woodenshoe-WebApp.azurewebsites.net"

# Get the current traffic manager profile
$tmProfile = Get-AzureRmTrafficManagerProfile -ResourceGroupName $resourceGroupName -Name $tmName 

# Get a reference to an existing web app
$webApp = Get-AzureRmWebApp -ResourceGroupName $resourceGroupName -Name $webAppName

# Add the web app endpoint to the traffic manager profile
New-AzureRmTrafficManagerEndpoint -ResourceGroupName $resourceGroupName -ProfileName $tmProfile.Name `
    -Name $newTmEndpointName -Type AzureEndpoints -EndpointStatus Enabled `
    -TargetResourceId $webApp.Id
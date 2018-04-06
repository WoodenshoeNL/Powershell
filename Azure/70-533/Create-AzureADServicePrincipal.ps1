# Define properties for the AD app registration
$adAppName="contos0"
$adAppIdUris="https://contos0-app"

# Create a new app registration in Azure AD
$app = New-AzureRmADApplication -DisplayName $adAppName -IdentifierUris $adAppIdUris

# Create a new service principal for the application
$sp = New-AzureRmADServicePrincipal -ApplicationId $app.ApplicationId  
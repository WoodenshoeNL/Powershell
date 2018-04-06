# Define properties for the AD app registration
$adAppName="contos0"
$adAppIdUris="https://contos0-app"

# Create a new app registration in Azure AD
$app = New-AzureRmADApplication -DisplayName $adAppName -IdentifierUris $adAppIdUris 
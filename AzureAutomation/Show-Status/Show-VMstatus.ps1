$resourceGroupName = "Script"
$resourceGroupLocation = "westeurope"
$AutomationAccount = "Script-AA"

$VerbosePreference = "Continue"


$Cred = Get-AutomationPSCredential -Name "SAscript" -ResourceGroupName $resourceGroupName -AutomationAccountName $AutomationAccount


Add-AzureRmAccount -Credential $cred

#Select-AzureSubscription -SubscriptionName $subName 

Get-AzureRmVM
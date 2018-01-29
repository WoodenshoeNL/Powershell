#$resourceGroupName = "Script"
#$resourceGroupLocation = "westeurope"
#$AutomationAccount = "Script-AA"

#$VerbosePreference = "Continue"


$Cred = Get-AutomationPSCredential -Name "SAscript"


Add-AzureRmAccount -Credential $cred

#Select-AzureSubscription -SubscriptionName $subName 

Get-AzureRmVM
#$resourceGroupName = "Script"
#$resourceGroupLocation = "westeurope"
#$AutomationAccount = "Script-AA"

#$VerbosePreference = "Continue"


$Cred = Get-AutomationPSCredential -Name "admin"

$subName = Get-AutomationVariable -Name 'Subscription'

Add-AzureRmAccount -Credential $cred 

Select-AzureSubscription -SubscriptionName $subName 

Get-AzureRmVM
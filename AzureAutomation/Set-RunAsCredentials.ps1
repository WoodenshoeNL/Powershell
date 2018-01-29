
$resourceGroupName = "Script"
$resourceGroupLocation = "westeurope"
$AutomationAccount = "Script-AA"


$Credential = Get-Credential -Message 'Enter AA Runas Credentials'
New-AzureRmAutomationCredential -Name "SAscript" -Description "AA Runas account" -Value $Credential -ResourceGroupName $ResourceGroupName -AutomationAccountName $AutomationAccount
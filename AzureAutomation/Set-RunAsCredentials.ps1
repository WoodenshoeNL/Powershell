
$resourceGroupName = "Script"
$resourceGroupLocation = "westeurope"
$AutomationAccount = "Script-AA"


$Credential.Password

$Cred = Get-Credential -Message 'Enter AA Runas Credentials'
$Credential = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $cred.UserName, $Cred.Password
New-AzureRmAutomationCredential -Name "SAscript1" -Description "AA Runas account" -Value $Credential -ResourceGroupName $ResourceGroupName -AutomationAccountName $AutomationAccount
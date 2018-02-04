#Parameters
Param(
   [Parameter(Mandatory=$true)]
   [string]$Gebruiker,
   [Parameter(Mandatory=$true)]
   [string]$TelefoonNummer,
   [switch]$Extern,
   [switch]$VerboseScript

) #end param

#Settings
if($VerboseScript){
    $VerbosePreference = "Continue"
}

#import-module AzureAD
#Import-Module MSOnline
Import-Module ActiveDirectory

#Variable
$UPN = "$Gebruiker@domain.nl"
$SIP = "sip:$UPN"
$SkypePool = "skype.domain.int"


#Get Credentials

$O365CREDS = Get-Credential -credential "<1>@beheer.domain.nl"
$ONPREMCREDS = Get-Credential -credential "domain.int\<2>"

Write-Host "[@] Start Gebruiker: $Gebruiker" -ForegroundColor "DarkYellow"

#account configureren
Write-Host "[->] AD Properties" -ForegroundColor "DarkYellow"
Set-ADUser -Identity $Gebruiker -Description "Winvision User" -UserPrincipalName $UPN -OfficePhone $TelefoonNummer
$user = get-aduser -Identity $Gebruiker -Properties *

if ($user.Company -eq $null){
    Write-Host "[!!] Company Leeg" -ForegroundColor "Red"
}
if ($user.Department -eq $null){
    Write-Host "[!!] Department Leeg" -ForegroundColor "Red"
}
if ($user.Title -eq $null){
    Write-Host "[!!] Job Title Leeg" -ForegroundColor "Red"
}

Write-Host "[->] Group Membership" -ForegroundColor "DarkYellow"
if($Extern){
    "Externe Gebruiker"
    Add-ADGroupMember -Identity "F_Externe_group" -Member $Gebruiker
}
else{
    Add-ADGroupMember -Identity "F_Interne_group" -Member $Gebruiker
}

#mailbox permissies
Write-Host "[*] Logon to Exchange" -ForegroundColor "Yellow"
$ExchSESSION = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri http://exchange.domain.int/PowerShell/ -Authentication Kerberos
Write-Host "[->] Setting Mailbox Folder Permissions" -ForegroundColor "DarkYellow"
Invoke-Command -Session $ExchSESSION -ScriptBlock {
    param($Gebruiker)
    Add-MailboxFolderPermission -id "$Gebruiker@domain.nl:\calendar" -user "Winvision medewerkers intern" -accessrights Reviewer 
} -ArgumentList $Gebruiker


#Skype
Write-Host "[*] Logon to Skype" -ForegroundColor "Yellow"
$SkypeSESSION = New-PSSession -ComputerName "skype.domain.int" -Credential $ONPREMCREDS -Authentication Kerberos

Import-PSSession -Session $SkypeSESSION -Module SkypeForBusiness, ActiveDirectory -AllowClobber
Write-Host "[->] Enable Skype" -ForegroundColor "DarkYellow"
Enable-CsUser -Identity $Gebruiker -RegistrarPool $SkypePool -SipAddress $SIP
set-CsUser -Identity $Gebruiker -LineURI "tel:$TelefoonNummer" -EnterpriseVoiceEnabled $True #-HostedVoiceMail $True
Grant-CsVoicePolicy -Identity $Gebruiker -PolicyName "NL-Internationaal"
Grant-CsExternalAccessPolicy -Identity $Gebruiker -PolicyName "Allow Federation+Public+Outside Access"


#mailbox verplaatsen naar Office 365
Write-Host "[*] Logon to Office 365" -ForegroundColor "Yellow"
$O365SESSION = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://ps.outlook.com/powershell -Credential $O365CREDS -Authentication Basic -AllowRedirection

Import-PSSession $O365SESSION
Connect-MsolService -Credential $O365CREDS
Write-Host "[->] Move Mailbox to Office 365" -ForegroundColor "DarkYellow"
New-MoveRequest -Identity "$Gebruiker@domain.nl" -Remote -RemoteHostName exchange.domain.nl -TargetDeliveryDomain domain.mail.onmicrosoft.com -RemoteCredential $ONPREMCREDS -BadItemLimit 1000

$movereq = $null
$iter = 0
Do
{
    Start-Sleep -Seconds 10
    $movereq = Get-MoveRequest -Identity "$Gebruiker@domain.nl"
    $status = $($movereq.status)
    $iter++
    "[++] Moving Mailbox - $iter" -ForegroundColor "green"
 
}While (($status -eq 'InProgress' -or $status -eq 'Queued' -or $status -eq 'CompletionInProgress') -and $iter -lt 36)
 
#office 365 licentie
Write-Host "[->] Setting Office 365 Licenses" -ForegroundColor "DarkYellow"
Set-MsolUser -UserPrincipalName "$Gebruiker@domain.nl" -UsageLocation "NL"
Set-MsolUserLicense -UserPrincipalName "$Gebruiker@domain.nl" -AddLicenses "domain:ENTERPRISEPREMIUM_NOPSTNCONF"


Write-Host "[#######################################] Finished" -ForegroundColor "DarkYellow"

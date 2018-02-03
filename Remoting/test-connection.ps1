$Gebruiker = "Testgebruiker"

#Settings
if($VerboseScript){
    $VerbosePreference = "Continue"
}

#Variable
$UPN = "$Gebruiker@domain.nl"


#Get Credentials

$O365CREDS = Get-Credential -credential "<1>@beheer.domain.nl"
$ONPREMCREDS = Get-Credential -credential "domain.int\<2>"


#mailbox
$ExchSESSION = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri http://server.domain.int/PowerShell/ -Authentication Kerberos

Invoke-Command -Session $ExchSESSION -ScriptBlock {
    param($Gebruiker)
    get-mailbox -Identity $Gebruiker
} -ArgumentList $Gebruiker


#Skype
$SkypeSESSION = New-PSSession -ComputerName "server2.domain.int" -Credential $ONPREMCREDS -Authentication Kerberos

Import-PSSession -Session $SkypeSESSION -Module SkypeForBusiness, ActiveDirectory -AllowClobber
get-CsUser -Identity $UPN



#Office 365

$O365SESSION = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://ps.outlook.com/powershell -Credential $O365CREDS -Authentication Basic -AllowRedirection

Import-PSSession -Session $O365SESSION #-AllowClobber

Connect-MsolService -Credential $O365CREDS;
get-MsolUser -UserPrincipalName "$Gebruiker@domain.nl" 


Get-PSSession | Remove-PSSession
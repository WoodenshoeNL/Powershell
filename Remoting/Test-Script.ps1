#Parameters
Param(
   [Parameter(Mandatory=$true)]
   [string]$Gebruiker,
   [Parameter(Mandatory=$true)]
   [string]$TelefoonNummer
) #end param

if($(Test-Path("c:\script")) -eq $false){
    New-Item -ItemType directory -Path c:\script
}

Add-Content -path "c:\script\test.txt" -Value $(Get-Date)

Add-Content -path "c:\script\test.txt" -Value $(Get-Service)

Add-Content -path "c:\script\$Gebruiker.txt" -Value $($TelefoonNummer)

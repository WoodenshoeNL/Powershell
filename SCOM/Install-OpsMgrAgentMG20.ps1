
$hostname = $([System.Net.Dns]::GetHostByName(($env:computerName))).hostname

#copy agent files
$remotepath = "\\tsclient\C\Operations Manager\Agent_2016"
$path = "C:\Install"

Copy-Item $remotepath $path -Recurse

#import Root Certs

$certPath = "C:\Install\Agent_2016\certnew.p7b"
$certPath2 = "C:\Install\Agent_2016\CAchain.p7b"
Import-Certificate -FilePath $certpath -CertStoreLocation Cert:\LocalMachine\Root
Import-Certificate -FilePath $certpath2 -CertStoreLocation Cert:\LocalMachine\Root

#Install Agent

& "C:\Install\Agent_2016\install_agent_MG20.cmd"

#Add Management Group MG30

& "C:\Install\Agent_2016\add-mangementgroup.ps1"

#install Rollup Update Pack

& "C:\Install\Agent_2016\ur4\KB4024941-AMD64-Agent.msp"


#Add Servers to hostfile

if(-not (Resolve-DnsName mgmt-opm31.management.int -ea ignore)) 
{
    Add-Content -path "C:\Windows\System32\drivers\etc\hosts" -Value "#"
    Add-Content -path "C:\Windows\System32\drivers\etc\hosts" -Value "10.212.8.26     mgmt-opm31.management.int"
    Add-Content -path "C:\Windows\System32\drivers\etc\hosts" -Value "10.212.8.27     mgmt-opm32.management.int"
    Add-Content -path "C:\Windows\System32\drivers\etc\hosts" -Value "#"
    Add-Content -path "C:\Windows\System32\drivers\etc\hosts" -Value "10.212.8.203     mgmt-opm21.management.int"
    Add-Content -path "C:\Windows\System32\drivers\etc\hosts" -Value "10.212.8.204     mgmt-opm22.management.int"
}

#Install Computer Cert
if(Test-Path "C:\Install\Agent_2016\Cert\$hostname.pfx" )
{
    $mypwd = Get-Credential -UserName 'Enter password below' -Message 'Enter password below'
    Import-PfxCertificate -FilePath "C:\Install\Agent_2016\Cert\$hostname.pfx" -CertStoreLocation Cert:\LocalMachine\My -Password $mypwd.Password 
}
#

#Start CertImport
& "C:\Install\Agent_2016\SupportTools\AMD64\MOMCertImport.exe /subjecname $hostname"
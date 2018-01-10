
#copy agent files
$remotepath = "\\tsclient\C\Operations Manager\Agent_2016"
$path = "C:\Install"

Copy-Item $remotepath $path -Recurse

#import Root Certs

$certPath = "C:\Install\Agent_2016\certnew.p7b"
Import-Certificate -FilePath $certpath -CertStoreLocation Cert:\LocalMachine\Root

#Install Agent

& "C:\Install\Agent_2016\install_agent.cmd"

#install Rollup Update Pack

& "C:\Install\Agent_2016\ur4\KB4024941-AMD64-Agent.msp"


#Add Servers to hostfile

Add-Content -path "C:\Windows\System32\drivers\etc\hosts" -Value "#"
Add-Content -path "C:\Windows\System32\drivers\etc\hosts" -Value "10.212.8.26     mgmt-opm31.management.int"
Add-Content -path "C:\Windows\System32\drivers\etc\hosts" -Value "10.212.8.27     mgmt-opm32.management.int"


#Start Cert MMC Console
& "C:\Install\Agent_2016\Cert.msc"

#wacht
Read-Host "Press Enter"

#Start CertImport
& "C:\Install\Agent_2016\SupportTools\AMD64\MOMCertImport.exe"
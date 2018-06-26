#md C:\script

robocopy "\\tsclient\C\Operations Manager\_Script\Install-RootCert" "C:\script\Install-RootCert"

powershell -Command "Start-Process powershell -Verb RunAs -ArgumentList '-noexit -ExecutionPolicy Bypass','-command &{C:\script\Install-RootCert\Install-RootCert.ps1;Set-Location C:\script\Install-RootCert}'"

timeout 5




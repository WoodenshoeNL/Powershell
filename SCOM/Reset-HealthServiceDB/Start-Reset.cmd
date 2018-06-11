#md C:\script

robocopy "\\tsclient\C\Operations Manager\_Script\Reset-HealthServiceDB" "C:\script\Reset-HealthServiceDB"

powershell -Command "Start-Process powershell -Verb RunAs -ArgumentList '-noexit','-command &{C:\script\Reset-HealthServiceDB\Reset-HealthServiceDB.ps1;Set-Location C:\script\Reset-HealthServiceDB}'"

timeout 30




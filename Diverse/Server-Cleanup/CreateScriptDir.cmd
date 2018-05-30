md C:\script

robocopy "\\tsclient\C\Operations Manager\_Script\Cleanup" "C:\script\Cleanup"

powershell -Command "Start-Process powershell -Verb RunAs -ArgumentList '-noexit','-command &{Set-Location C:\script\Cleanup}'"

timeout 5

explorer c:\script


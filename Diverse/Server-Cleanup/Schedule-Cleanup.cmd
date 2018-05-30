#md C:\script

robocopy "\\tsclient\C\Operations Manager\_Script\Cleanup" "C:\script\Cleanup"

powershell -Command "Start-Process powershell -Verb RunAs -ArgumentList '-noexit','-command &{C:\script\cleanup\Schedule-ServerCleanup.ps1}'"

timeout 5





robocopy "\\tsclient\C\Operations Manager\Agent_2016" "C:\Install\Agent_2016"

powershell -Command "Start-Process powershell -Verb RunAs -ArgumentList '-noexit','-command &{C:\Install\Agent_2016\Install-OpsMgrAgent.ps1;Set-Location C:\Install\Agent_2016}'"

timeout 5




#Invoke-AzureRmVMRunCommand -ResourceGroupName 'rgname' -Name 'vmname' -CommandId 'RunPowerShellScript' -ScriptPath 'sample.ps1' -Parameter @{"arg1" = "var1";"arg2" = "var2"}

Invoke-AzureRmVMRunCommand -ResourceGroupName 'ContainerDemo' -Name 'VM-Container001' -CommandId 'RunPowerShellScript' -ScriptPath 'C:\GIT\Powershell\Azure\remote\test-Invokescript.ps1'
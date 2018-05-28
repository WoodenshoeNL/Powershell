
#copy agent files
$remotepath = "\\mgmt-rds02.management.int\c$\Operations Manager\Agent_2016\Scripts\Cleanup"
$ScriptPath = "C:\script"

if ($(Test-Path $ScriptPath) -eq $false ) {
    New-Item -ItemType directory -Path $ScriptPath 
}

Copy-Item $remotepath $ScriptPath -Recurse


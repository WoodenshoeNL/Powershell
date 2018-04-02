$acctKey = ConvertTo-SecureString -String "<<Access Key>>" -AsPlainText -Force
$credential = New-Object System.Management.Automation.PSCredential -ArgumentList "Azure\testfileswoodenshoe", $acctKey
New-PSDrive -Name Z -PSProvider FileSystem -Root "\\testfileswoodenshoe.file.core.windows.net\testshare" -Credential $credential -Persist
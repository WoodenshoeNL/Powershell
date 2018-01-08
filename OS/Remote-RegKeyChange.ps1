
#Reg Key 1

$RegName1 = 'ChannelCertificateSerialNumber'
$RegPath1 = 'HKLM:\\SOFTWARE\Microsoft\Microsoft Operations Manager\3.0\Machine Settings'
$RegValue1 = '00000'

#Reg Key 2

$RegName2 = 'ChannelCertificateSerialNumber2'
$RegPath2 = 'HKLM:\\SOFTWARE\Microsoft\Microsoft Operations Manager\3.0\Machine Settings'
$RegValue2 = '00000'


foreach($server in $(get-content .\servers.txt) )
{
    Invoke-Command -ComputerName $server -ScriptBlock {
        Set-ItemProperty -Name $RegName1 -Path $RegPath1 -Value $RegValue1;
        Set-ItemProperty -Name $RegName2 -Path $RegPath2 -Value $RegValue2
    }
}
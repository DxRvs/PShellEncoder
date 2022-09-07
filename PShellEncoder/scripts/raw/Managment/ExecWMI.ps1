<#
<description>Start process via wmi
<description>
#>
<#
<categories>
Managment,remote
<categories>
#>
$rhost ="127.0.0.1"
$arg="cmd /c hostname > c:\hostname.txt"
$username = 'xxxxxx'
$password = 'xxxxxxx'
$securePassword = ConvertTo-SecureString $password -AsPlainText -Force
$credential = New-Object System.Management.Automation.PSCredential $username, $securePassword
$process = Invoke-WmiMethod -ComputerName $rhost -Class Win32_Process -Name Create -ArgumentList $arg -Credential $credential
echo $process.ProcessId



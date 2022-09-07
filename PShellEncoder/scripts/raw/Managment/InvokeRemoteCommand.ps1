<#
<description>Invoke a remote command wia winrm service
<description>
#>
<#
<categories>
Managment,remote
<categories>
#>
$username = 'xxxxxx'
$password = 'xxxxxx'
$securePassword = ConvertTo-SecureString $password -AsPlainText -Force
$credential = New-Object System.Management.Automation.PSCredential $username, $securePassword
$e = Invoke-Command -ComputerName HOST -ScriptBlock { hostname } -credential $credential
echo $e
$Error[0].Exception.Message


<#
<description>List a remote share
<description>
#>
<#
<categories>
remote
<categories>
#>

$username = 'xxxxxx'
$password = 'xxxxxx'
$rhost = 'hostname'
$securePassword = ConvertTo-SecureString $password -AsPlainText -Force
$credential = New-Object System.Management.Automation.PSCredential $username, $securePassword
$e = get-WmiObject -class Win32_Share -computer $rhost -Credential $credential 
$Error[0].Exception.Message

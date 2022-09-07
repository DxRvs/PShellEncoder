<#
<description>Invoke a remote command wia winrm service with configuring a localhost
<description>
#>
<#
<categories>
Managment,remote
<categories>
#>
Restart-Service WinRM -force
Set-Item wsman:\localhost\client\trustedhosts * -force
Restart-Service WinRM -force 
$username = 'xxxxxx'
$password = 'xxxxxx'
$securePassword = ConvertTo-SecureString $password -AsPlainText -Force
$credential = New-Object System.Management.Automation.PSCredential $username, $securePassword
$e = Invoke-Command -ComputerName HOST -ScriptBlock { hostname } -credential $credential
echo $e
$Error[0].Exception.Message
Set-Item wsman:\localhost\client\trustedhosts '' -force
Restart-Service WinRM -force


<#
<description>Establishing tcp connection
<description>
#>
<#
<categories>
network
<categories>
#>
$c = New-Object System.Net.Sockets.TcpClient
$e = $c.BeginConnect("8.8.8.8",80,$null,$null)
Start-Sleep -Milli 3000
if($c.Connected) {
echo Open
}else{
echo Close
}


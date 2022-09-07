<#
<description>Estableshing TCP connections to target in arrays
<description>
#>
<#
<categories>
network
<categories>
#>
[string[]]$EndAddress= @("8.8.8.8","8.8.4.4")
[int[]]$Ports = @(80,443)
for($i=0;$i -le ($EndAddress.Count-1);$i++){
for($j=0;$j -le ($Ports.Count-1);$j++){
$client = New-Object System.Net.Sockets.TcpClient
$beginConnect = $client.BeginConnect($EndAddress[$i],$Ports[$j],$null,$null)
Start-Sleep -Milli 3000
if($client.Connected) {
$res = "OPEN"+ $EndAddress[$i]+":"+$Ports[$j].toString()
Write-Host $res
}else{
$res = "CLOSE "+ $EndAddress[$i]+":"+$Ports[$j].toString()
Write-Host $res
}}}

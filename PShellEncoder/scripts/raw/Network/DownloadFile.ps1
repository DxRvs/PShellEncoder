<#
<description>Downloads a file from a web server
<description>
#>
<#
<categories>
Network
<categories>
#>

$url = "http://localhost/file.txt"
$webclient = New-Object System.Net.WebClient
[System.Net.ServicePointManager]::ServerCertificateValidationCallback = {$true}
#$WebProxy = New-Object System.Net.WebProxy("http://1.1.1.1:3128",$true)
$webclient.Proxy = [System.Net.GlobalProxySelection]::GetEmptyWebProxy()
$webclient.DownloadFile($url, "file.txt")


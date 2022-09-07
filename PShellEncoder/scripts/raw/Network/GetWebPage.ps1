<#
<description>Get a web page. Use GET request
<description>
#>
<#
<categories>
network
<categories>
#>
$url = "http://localhost"
$webclient = New-Object System.Net.WebClient
[System.Net.ServicePointManager]::ServerCertificateValidationCallback = {$true}
$webclient.Proxy = [System.Net.GlobalProxySelection]::GetEmptyWebProxy()
Write-Output $webclient.DownloadString($url)


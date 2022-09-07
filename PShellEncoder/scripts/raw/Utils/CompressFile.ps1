<#
<description>Compress file with use IO.Compression.DeflateStream
<description>
#>
<#
<categories>
utils
<categories>
#>
$source = "filename"
$sdata = [System.IO.File]::OpenRead($source)
$rdata = [System.IO.File]::Create($source+".zip")
$DeflateStream = New-Object IO.Compression.DeflateStream ($rdata, [IO.Compression.CompressionMode]::Compress)
$sdata.CopyTo($DeflateStream);
$sdata.Dispose()
$DeflateStream.Dispose()
$sdata.Close()
$rdata.Close()


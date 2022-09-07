<#
<description>Decompresed a file via IO.Compression.DeflateStream
<description>
#>
<#
<categories>
utils
<categories>
#>

$ProcessCompressedDumpPath = "compressedFile.bin"
$data = [System.IO.File]::OpenRead($ProcessCompressedDumpPath)
$decompr = New-Object  IO.Compression.DeflateStream ($data ,[System.IO.Compression.CompressionMode]::Decompress)
$result = [System.IO.File]::Create($ProcessCompressedDumpPath+"s")
$decompr.CopyTo($result)
$decompr.Dispose()
$result.Dispose()
Get-ChildItem ($ProcessCompressedDumpPath+"s")

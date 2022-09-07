<#
<description>Join file
<description>
#>
<#
<categories>
utils
<categories>
#>
$pt = "C:\temp\"
$result = "C:\temp\result.jpg"
$parts = Get-ChildItem -Path  $pt -Filter "split*" | sort { [int]$_.name.Split(".")[1] }
$toFile = [io.file]::OpenWrite($result)
foreach($part in $parts){
	$p = $pt+$part
	$bytes = 	[io.file]::ReadAllBytes($p)
	$toFile.Write($bytes,0,$bytes.Length)
}
$toFile.Close()



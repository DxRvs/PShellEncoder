<#
<description>Search for a file in directories
<description>
#>
<#
<categories>
utils
<categories>
#>
$c = Get-ChildItem -Path ".." -Filter test.js  -Recurse -ErrorAction SilentlyContinue -Force
$c | Foreach-Object {
$d = $_.Directory.FullName
Write-Output $d
 exit
}
Write-Output "not found"

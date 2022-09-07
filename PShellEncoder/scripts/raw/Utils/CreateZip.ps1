<#
<description>Create zip file from folder
need .NET Framework 4.5
<description>
#>
<#
<categories>
utils
<categories>
#>
Add-Type -Assembly 'System.IO.Compression.FileSystem'; 
[System.IO.Compression.ZipFile]::CreateFromDirectory('C:\target', 'C:\result.zip');
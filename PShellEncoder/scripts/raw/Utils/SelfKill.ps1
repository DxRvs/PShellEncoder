<#
<description>Kill current powershell process
<description>
#>
<#
<categories>
note
<categories>
#>
Stop-Process -Id ([System.Diagnostics.Process]::GetCurrentProcess().id)
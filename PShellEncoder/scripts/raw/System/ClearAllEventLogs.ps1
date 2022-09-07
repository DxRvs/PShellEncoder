<#
<description>Remove all windows event logs
<description>
#>
<#
<categories>
system
<categories>
#>
wevtutil el | Foreach-Object {wevtutil cl "$_"}

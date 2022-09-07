<#
<description>Send string into the window
<description>
#>
<#
<categories>
utils
<categories>
#>
$str = "send string"
$char = ('+','^','%','~','(',')','[',']')
$myshell = New-Object -com "Wscript.Shell"
$myshell.AppActivate("windows title or int id")
$str=$str.Replace("{","57#86#5#46215");
$str=$str.Replace("}","57#86#5#46216");
foreach($c in $char){
$str=$str.Replace($c,"{"+$c+"}")
}
$str=$str.Replace("57#865#46215","{");
$str=$str.Replace("57#865#46216","}");
echo $str
$myshell.sendkeys($str);


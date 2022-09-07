<#
<description>Encode a file to base64 string
<description>
#>
<#
<categories>
utils
<categories>
#>
$fname=""
$text = gc $fname
$Bytes = [System.Text.Encoding]::Unicode.GetBytes($text)
$EncodedText =[Convert]::ToBase64String($Bytes)
echo $EncodedText
$source =[System.Text.Encoding]::Unicode.GetString([System.Convert]::FromBase64String($EncodedText))
echo $source


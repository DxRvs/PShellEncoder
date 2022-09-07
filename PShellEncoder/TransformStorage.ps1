### Invoke-Obfuscation functions
. ($PSScriptRoot+[IO.Path]::DirectorySeparatorChar+"Invoke-Obfuscation\Out-CompressedCommand.ps1")
. ($PSScriptRoot+[IO.Path]::DirectorySeparatorChar+"Invoke-Obfuscation\Out-EncodedAsciiCommand.ps1")
. ($PSScriptRoot+[IO.Path]::DirectorySeparatorChar+"Invoke-Obfuscation\Out-EncodedBinaryCommand.ps1")
. ($PSScriptRoot+[IO.Path]::DirectorySeparatorChar+"Invoke-Obfuscation\Out-EncodedBXORCommand.ps1")
. ($PSScriptRoot+[IO.Path]::DirectorySeparatorChar+"Invoke-Obfuscation\Out-EncodedHexCommand.ps1")
. ($PSScriptRoot+[IO.Path]::DirectorySeparatorChar+"Invoke-Obfuscation\Out-EncodedOctalCommand.ps1")
. ($PSScriptRoot+[IO.Path]::DirectorySeparatorChar+"Invoke-Obfuscation\Out-EncodedSpecialCharOnlyCommand.ps1")
. ($PSScriptRoot+[IO.Path]::DirectorySeparatorChar+"Invoke-Obfuscation\Out-EncodedWhitespaceCommand.ps1")
. ($PSScriptRoot+[IO.Path]::DirectorySeparatorChar+"Invoke-Obfuscation\Out-ObfuscatedAst.ps1")
. ($PSScriptRoot+[IO.Path]::DirectorySeparatorChar+"Invoke-Obfuscation\Out-ObfuscatedStringCommand.ps1")
. ($PSScriptRoot+[IO.Path]::DirectorySeparatorChar+"Invoke-Obfuscation\Out-ObfuscatedTokenCommand.ps1")
. ($PSScriptRoot+[IO.Path]::DirectorySeparatorChar+"Invoke-Obfuscation\Out-SecureStringCommand.ps1")

### Self modules
. ($PSScriptRoot+[IO.Path]::DirectorySeparatorChar+"modules\obfvariables.ps1")
. ($PSScriptRoot+[IO.Path]::DirectorySeparatorChar+"modules\to-oneLine.ps1")
. ($PSScriptRoot+[IO.Path]::DirectorySeparatorChar+"modules\to-oneLine2.ps1")

#############------------TRANSFORMS---------------------------
class Transform{

	[string] getName(){
		return ""
	}
		[string] getExample(){
		return ""
	}
		[string] getDescription(){
		return ""
	}

		[string] run([string]$source){
	throw("Must Override Method")
	}
		
}
class Transform_DelimitedAndConcatenated:Transform{
	$name = "DelimitedAndConcatenated"
	$description = "Delimits and concatenates an input PowerShell command. The purpose is to highlight to the Blue Team that there are more novel ways to encode a PowerShell command other than the most common Base64 approach."
	$example = "{Write-Host 'Hello World!' -ForegroundColor Green; Write-Host 'Obfuscation Rocks!' -ForegroundColor Green}  --->>>  IEX ((('Write-H'+'ost x'+'lcHello'+' Wor'+'ld!xlc -F'+'oregroundC'+'o'+'lor Gre'+'en'+'; Write-Host '+'xlcObf'+'u'+'sc'+'ation '+'Rocks!xl'+'c'+' '+'-'+'Foregrou'+'nd'+'C'+'olor Green')  -Replace 'xlc',[Char]39) )"
	
	[string] getName(){
		return $this.name
	}
		[string] getExample(){
		return $this.example
	}
		[string] getDescription(){
		return $this.description
	}
	[string] run([string]$source){
		$res  = Out-StringDelimitedAndConcatenated  -ScriptString $source
		return $res
	}
}
class Transform_DelimitedConcatenatedAndReordered:Transform{
	$name = "DelimitedConcatenatedAndReordered"
	$description = "Delimits, concatenates and reorders the concatenated substrings of an input PowerShell command. The purpose is to highlight to the Blue Team that there are more novel ways to encode a PowerShell command other than the most common Base64 approach."
	$example = "Write-Host 'Hello World!' -ForegroundColor Green; Write-Host 'Obfuscation Rocks!' -ForegroundColor Green  --->>>  ((`"{16}{5}{6}{14}{3}{19}{15}{10}{18}{17}{0}{2}{7}{8}{12}{9}{11}{4}{13}{1}`"-f't','en','ion R','9 -Fore','Gr','e-Host 0i9Hello W','or','ocks!0i9 -Fo','regroun','olo','ite-Hos','r ','dC','e','ld!0i','; Wr','Writ','sca','t 0i9Obfu','groundColor Green')).Replace('0i9',[String][Char]39) |IEX"
	
	[string] getName(){
		return $this.name
	}
		[string] getExample(){
		return $this.example
	}
		[string] getDescription(){
		return $this.description
	}
	[string] run([string]$source){
		$res  = Out-StringDelimitedConcatenatedAndReordered  -ScriptString $source
		return $res
	}
}
class Transform_StringReversed:Transform{
	$name = "StringReversed"
	$description = "Concatenates and reverses an input PowerShell command. The purpose is to highlight to the Blue Team that there are more novel ways to encode a PowerShell command other than the most common Base64 approach."
	$example = "Write-Host 'Hello World!' -ForegroundColor Green; Write-Host 'Obfuscation Rocks!' -ForegroundColor Green  --->>>  sv 6nY  (`"XEI | )93]rahC[ f-)'n'+'eer'+'G'+' roloC'+'dnuo'+'rgeroF-'+' '+'}0{!sk'+'co'+'R '+'noitacsufb'+'O'+'}0'+'{ ts'+'oH-'+'etirW ;neer'+'G'+' rolo'+'C'+'dnu'+'orgeroF- }0{!d'+'l'+'roW'+' olleH}0{ tsoH-et'+'ir'+'W'(( `");IEX ( (  gcI  vARiaBlE:6ny  ).valUE[ -1..-( (  gcI  vARiaBlE:6ny  ).valUE.Length ) ]-Join '' )"
	
	[string] getName(){
		return $this.name
	}
		[string] getExample(){
		return $this.example
	}
		[string] getDescription(){
		return $this.description
	}
	[string] run([string]$source){
		$res  = Out-StringReversed -ScriptString $source
		return $res
	}
}
class Transform_TokenCommand_Strin1:Transform{
	$name = "TokenCommand_Strin1"
	$description = "Obfuscate String tokens (suggested to run first)"
	$example = "Concatenate --> e.g. ('co'+'ffe'+'e')"
	
	[string] getName(){
		return $this.name
	}
		[string] getExample(){
		return $this.example
	}
		[string] getDescription(){
		return $this.description
	}
	[string] run([string]$source){
		$sblock = [System.Management.Automation.ScriptBlock]::Create($source)
	    $res= Out-ObfuscatedTokenCommand -ScriptBlock $sblock -TokenTypeToObfuscate String -ObfuscationLevel 1
		return $res
	}
}
class Transform_TokenCommand_Strin2:Transform{
	$name = "TokenCommand_Strin2"
	$description = "Obfuscate String tokens (suggested to run first)"
	$example = "Reorder     --> e.g. ('{1}{0}'-f'ffee','co')"
	
	[string] getName(){
		return $this.name
	}
		[string] getExample(){
		return $this.example
	}
		[string] getDescription(){
		return $this.description
	}
	[string] run([string]$source){
		$sblock = [System.Management.Automation.ScriptBlock]::Create($source)
	    $res= Out-ObfuscatedTokenCommand -ScriptBlock $sblock -TokenTypeToObfuscate String -ObfuscationLevel 2
		return $res
	}
}
class Transform_TokenCommand_Command1:Transform{
	$name = "TokenCommand_Command1"
	$description = "Obfuscate Command tokens"
	$example = "Ticks                   --> e.g. Ne`w-O`Bject"
	
	[string] getName(){
		return $this.name
	}
		[string] getExample(){
		return $this.example
	}
		[string] getDescription(){
		return $this.description
	}
	[string] run([string]$source){
		$sblock = [System.Management.Automation.ScriptBlock]::Create($source)
	    $res= Out-ObfuscatedTokenCommand -ScriptBlock $sblock -TokenTypeToObfuscate Command -ObfuscationLevel 1
		return $res
	}
}
class Transform_TokenCommand_Command2:Transform{
	$name = "TokenCommand_Command2"
	$description = "Obfuscate Command tokens"
	$example = "Splatting + Concatenate --> e.g. &('Ne'+'w-Ob'+'ject')"
	
	[string] getName(){
		return $this.name
	}
		[string] getExample(){
		return $this.example
	}
		[string] getDescription(){
		return $this.description
	}
	[string] run([string]$source){
		$sblock = [System.Management.Automation.ScriptBlock]::Create($source)
	    $res= Out-ObfuscatedTokenCommand -ScriptBlock $sblock -TokenTypeToObfuscate Command -ObfuscationLevel 2
		return $res
	}
}
class Transform_TokenCommand_Command3:Transform{
	$name = "TokenCommand_Command3"
	$description = "Obfuscate Command tokens"
	$example = "Splatting + Reorder     --> e.g. &('{1}{0}'-f'bject','New-O')"
	
	[string] getName(){
		return $this.name
	}
		[string] getExample(){
		return $this.example
	}
		[string] getDescription(){
		return $this.description
	}
	[string] run([string]$source){
		$sblock = [System.Management.Automation.ScriptBlock]::Create($source)
	    $res= Out-ObfuscatedTokenCommand -ScriptBlock $sblock -TokenTypeToObfuscate Command -ObfuscationLevel 3 
		return $res
	}
}
class Transform_TokenCommand_Argument1:Transform{
	$name = "TokenCommand_Argument1"
	$description = "Obfuscate Argument tokens"
	$example = "Random Case --> e.g. nEt.weBclIenT"
	
	[string] getName(){
		return $this.name
	}
		[string] getExample(){
		return $this.example
	}
		[string] getDescription(){
		return $this.description
	}
	[string] run([string]$source){
		$sblock = [System.Management.Automation.ScriptBlock]::Create($source)
	    $res= Out-ObfuscatedTokenCommand -ScriptBlock $sblock -TokenTypeToObfuscate CommandArgument -ObfuscationLevel 1
		return $res
	}
}
class Transform_TokenCommand_Argument2:Transform{
	$name = "TokenCommand_Argument2"
	$description = "Obfuscate Argument tokens`nFor Powershell version < 5"
	$example = "Ticks       --> e.g. nE`T.we`Bc`lIe`NT"
	
	[string] getName(){
		return $this.name
	}
		[string] getExample(){
		return $this.example
	}
		[string] getDescription(){
		return $this.description
	}
	[string] run([string]$source){
		$sblock = [System.Management.Automation.ScriptBlock]::Create($source)
	    $res= Out-ObfuscatedTokenCommand -ScriptBlock $sblock -TokenTypeToObfuscate CommandArgument -ObfuscationLevel 2
		return $res
	}
}
class Transform_TokenCommand_Argument3:Transform{
	$name = "TokenCommand_Argument3"
	$description = "Obfuscate Argument tokens`nFor Powershell version < 5"
	$example = "Concatenate --> e.g. ('Ne'+'t.We'+'bClient')"
	
	[string] getName(){
		return $this.name
	}
		[string] getExample(){
		return $this.example
	}
		[string] getDescription(){
		return $this.description
	}
	[string] run([string]$source){
		$sblock = [System.Management.Automation.ScriptBlock]::Create($source)
	    $res= Out-ObfuscatedTokenCommand -ScriptBlock $sblock -TokenTypeToObfuscate CommandArgument -ObfuscationLevel 3
		return $res
	}
}
class Transform_TokenCommand_Argument4:Transform{
	$name = "TokenCommand_Argument4"
	$description = "Obfuscate Argument tokens`nFor Powershell version < 5"
	$example = "Reorder     --> e.g. ('{1}{0}'-f'bClient','Net.We')"
	
	[string] getName(){
		return $this.name
	}
		[string] getExample(){
		return $this.example
	}
		[string] getDescription(){
		return $this.description
	}
	[string] run([string]$source){
		$sblock = [System.Management.Automation.ScriptBlock]::Create($source)
	    $res= Out-ObfuscatedTokenCommand -ScriptBlock $sblock -TokenTypeToObfuscate CommandArgument -ObfuscationLevel 4
		return $res
	}
}
class Transform_TokenCommand_Member1:Transform{
	$name = "TokenCommand_Member1"
	$description = "Obfuscate Member tokens"
	$example = "Random Case --> e.g. dOwnLoAdsTRing"
	
	[string] getName(){
		return $this.name
	}
		[string] getExample(){
		return $this.example
	}
		[string] getDescription(){
		return $this.description
	}
	[string] run([string]$source){
		$sblock = [System.Management.Automation.ScriptBlock]::Create($source)
	    $res= Out-ObfuscatedTokenCommand -ScriptBlock $sblock -TokenTypeToObfuscate Member -ObfuscationLevel 1
		return $res
	}
}
class Transform_TokenCommand_Member2:Transform{
	$name = "TokenCommand_Member2"
	$description = "Obfuscate Member tokens"
	$example = "Ticks       --> e.g. d`Ow`NLoAd`STRin`g"
	
	[string] getName(){
		return $this.name
	}
		[string] getExample(){
		return $this.example
	}
		[string] getDescription(){
		return $this.description
	}
	[string] run([string]$source){
		$sblock = [System.Management.Automation.ScriptBlock]::Create($source)
	    $res= Out-ObfuscatedTokenCommand -ScriptBlock $sblock -TokenTypeToObfuscate Member -ObfuscationLevel 2
		return $res
	}
}
class Transform_TokenCommand_Member3:Transform{
	$name = "TokenCommand_Member3"
	$description = "Obfuscate Member tokens"
	$example = "Concatenate --> e.g. ('dOwnLo'+'AdsT'+'Ring').Invoke()"
	
	[string] getName(){
		return $this.name
	}
		[string] getExample(){
		return $this.example
	}
		[string] getDescription(){
		return $this.description
	}
	[string] run([string]$source){
		$sblock = [System.Management.Automation.ScriptBlock]::Create($source)
	    $res= Out-ObfuscatedTokenCommand -ScriptBlock $sblock -TokenTypeToObfuscate Member -ObfuscationLevel 3
		return $res
	}
}
class Transform_TokenCommand_Member4:Transform{
	$name = "TokenCommand_Member4"
	$description = "Obfuscate Member tokens"
	$example = "Reorder     --> e.g. ('{1}{0}'-f'dString','Downloa').Invoke()"
	
	[string] getName(){
		return $this.name
	}
		[string] getExample(){
		return $this.example
	}
		[string] getDescription(){
		return $this.description
	}
	[string] run([string]$source){
		$sblock = [System.Management.Automation.ScriptBlock]::Create($source)
	    $res= Out-ObfuscatedTokenCommand -ScriptBlock $sblock -TokenTypeToObfuscate Member -ObfuscationLevel 4
		return $res
	}
}
class Transform_TokenCommand_Variable1:Transform{
	$name = "TokenCommand_Variable1"
	$description = "Obfuscate Variable tokens"
	$example = 'Random Case + {} + Ticks --> e.g. ${c`hEm`eX}'
	
	[string] getName(){
		return $this.name
	}
		[string] getExample(){
		return $this.example
	}
		[string] getDescription(){
		return $this.description
	}
	[string] run([string]$source){
		$sblock = [System.Management.Automation.ScriptBlock]::Create($source)
	    $res= Out-ObfuscatedTokenCommand -ScriptBlock $sblock -TokenTypeToObfuscate Variable -ObfuscationLevel 1
		return $res
	}
}
class Transform_TokenCommand_Type1:Transform{
	$name = "TokenCommand_Type1"
	$description = "Obfuscate Type tokens"
	$example = "Type Cast + Concatenate --> e.g. [Type]('Con'+'sole')"
	
	[string] getName(){
		return $this.name
	}
		[string] getExample(){
		return $this.example
	}
		[string] getDescription(){
		return $this.description
	}
	[string] run([string]$source){
		$sblock = [System.Management.Automation.ScriptBlock]::Create($source)
	    $res= Out-ObfuscatedTokenCommand -ScriptBlock $sblock -TokenTypeToObfuscate Type -ObfuscationLevel 1
		return $res
	}
}
class Transform_TokenCommand_Type2:Transform{
	$name = "TokenCommand_Type2"
	$description = "Obfuscate Type tokens"
	$example = "Type Cast + Reordered   --> e.g. [Type]('{1}{0}'-f'sole','Con')"
	
	[string] getName(){
		return $this.name
	}
		[string] getExample(){
		return $this.example
	}
		[string] getDescription(){
		return $this.description
	}
	[string] run([string]$source){
		$sblock = [System.Management.Automation.ScriptBlock]::Create($source)
	    $res= Out-ObfuscatedTokenCommand -ScriptBlock $sblock -TokenTypeToObfuscate Type -ObfuscationLevel 2
		return $res
	}
}
class Transform_TokenCommand_Comment1:Transform{
	$name = "TokenCommand_Comment1"
	$description = "Remove all Comment tokens"
	$example = "Remove Comments   --> e.g. self-explanatory"
	
	[string] getName(){
		return $this.name
	}
		[string] getExample(){
		return $this.example
	}
		[string] getDescription(){
		return $this.description
	}
	[string] run([string]$source){
		$sblock = [System.Management.Automation.ScriptBlock]::Create($source)
	    $res= Out-ObfuscatedTokenCommand -ScriptBlock $sblock -TokenTypeToObfuscate Comment -ObfuscationLevel 1
		return $res
	}
}
class Transform_TokenCommand_WhiteSpace1:Transform{
	$name = "TokenCommand_WhiteSpace1"
	$description = "Insert random Whitespace (suggested to run last)"
	$example = "Random Whitespace --> e.g. .( 'Ne'  +'w-Ob' +  'ject')"
	
	[string] getName(){
		return $this.name
	}
		[string] getExample(){
		return $this.example
	}
		[string] getDescription(){
		return $this.description
	}
	[string] run([string]$source){
		$sblock = [System.Management.Automation.ScriptBlock]::Create($source)
	    $res= Out-ObfuscatedTokenCommand -ScriptBlock $sblock -TokenTypeToObfuscate RandomWhitespace -ObfuscationLevel 1
		return $res
	}
}
class Transform_TokenCommand_All:Transform{
	$name = "TokenCommand_All"
	$description = "Select All choices from above (random order)`n For Powershell version < 5"
	$example = "Execute ALL Token obfuscation techniques (random order)"
	
	[string] getName(){
		return $this.name
	}
		[string] getExample(){
		return $this.example
	}
		[string] getDescription(){
		return $this.description
	}
	[string] run([string]$source){
		$sblock = [System.Management.Automation.ScriptBlock]::Create($source)
	    $res= Out-ObfuscatedTokenCommand -ScriptBlock $sblock 
		return $res
	}
}
class Transform_Ast_NamedAttributeArgumentAst:Transform{
	$name = "Ast_NamedAttributeArgumentAst"
	$description = "Obfuscate NamedAttributeArgumentAst nodes"
	$example = 'Reorder e.g. [Parameter(Mandatory, ValueFromPipeline = $True)] --> [Parameter(Mandatory = $True, ValueFromPipeline)]'
	
	[string] getName(){
		return $this.name
	}
		[string] getExample(){
		return $this.example
	}
		[string] getDescription(){
		return $this.description
	}
	[string] run([string]$source){
	    $res = Out-ObfuscatedAst -ScriptString $source -AstTypesToObfuscate System.Management.Automation.Language.NamedAttributeArgumentAst
		
		return $res
	}
}
class Transform_Ast_ParamBlockAst:Transform{
	$name = "Ast_ParamBlockAst"
	$description = "Obfuscate ParamBlockAst nodes"
	$example = 'Reorder e.g. Param([Int]$One, [Int]$Two) --> Param([Int]$Two, [Int]$One)'
	
	[string] getName(){
		return $this.name
	}
		[string] getExample(){
		return $this.example
	}
		[string] getDescription(){
		return $this.description
	}
	[string] run([string]$source){
	    $res = Out-ObfuscatedAst -ScriptString $source -AstTypesToObfuscate System.Management.Automation.Language.ParamBlockAst
		
		return $res
	}
}
class Transform_Ast_ScriptBlockAst:Transform{
	$name = "Ast_ScriptBlockAst"
	$description = "Obfuscate ScriptBlockAst nodes"
	$example = 'Reorder e.g. { Begin {} Process {} End {} } --> { End {} Begin {} Process {} }'
	
	[string] getName(){
		return $this.name
	}
		[string] getExample(){
		return $this.example
	}
		[string] getDescription(){
		return $this.description
	}
	[string] run([string]$source){
	    $res = Out-ObfuscatedAst -ScriptString $source -AstTypesToObfuscate System.Management.Automation.Language.ScriptBlockAst
		
		return $res
	}
}
class Transform_Ast_AttributeAst:Transform{
	$name = "Ast_AttributeAst"
	$description = "Obfuscate AttributeAst nodes"
	$example = 'Reorder e.g. [Parameter(Position = 0, Mandatory)] --> [Parameter(Mandatory, Position = 0)]'
	
	[string] getName(){
		return $this.name
	}
		[string] getExample(){
		return $this.example
	}
		[string] getDescription(){
		return $this.description
	}
	[string] run([string]$source){
	    $res = Out-ObfuscatedAst -ScriptString $source -AstTypesToObfuscate System.Management.Automation.Language.AttributeAst
		
		return $res
	}
}
class Transform_Ast_BinaryExpressionAst:Transform{
	$name = "Ast_BinaryExpressionAst"
	$description = "Obfuscate BinaryExpressionAst nodes"
	$example = 'Reorder e.g. (2 + 3) * 4 --> 4 * (3 + 2)'
	
	[string] getName(){
		return $this.name
	}
		[string] getExample(){
		return $this.example
	}
		[string] getDescription(){
		return $this.description
	}
	[string] run([string]$source){
	    $res = Out-ObfuscatedAst -ScriptString $source -AstTypesToObfuscate System.Management.Automation.Language.BinaryExpressionAst
		
		return $res
	}
}
class Transform_Ast_HashtableAst:Transform{
	$name = "Ast_HashtableAst"
	$description = "Obfuscate HashtableAst nodes"
	$example = "Reorder e.g. @{ProviderName = 'Microsoft-Windows-PowerShell'; Id = 4104} --> @{Id = 4104; ProviderName = 'Microsoft-Windows-PowerShell'}"
	
	[string] getName(){
		return $this.name
	}
		[string] getExample(){
		return $this.example
	}
		[string] getDescription(){
		return $this.description
	}
	[string] run([string]$source){
	    $res = Out-ObfuscatedAst -ScriptString $source -AstTypesToObfuscate System.Management.Automation.Language.HashtableAst
		
		return $res
	}
}
class Transform_Ast_CommandAst:Transform{
	$name = "Ast_CommandAst"
	$description = "Obfuscate CommandAst nodes"
	$example = "Reorder e.g. Get-Random -Min 1 -Max 100 --> Get-Random -Max 100 -Min 1"
	
	[string] getName(){
		return $this.name
	}
		[string] getExample(){
		return $this.example
	}
		[string] getDescription(){
		return $this.description
	}
	[string] run([string]$source){
	    $res = Out-ObfuscatedAst -ScriptString $source -AstTypesToObfuscate System.Management.Automation.Language.CommandAst
		
		return $res
	}
}
class Transform_Ast_AssignmentStatementAst:Transform{
	$name = "Ast_AssignmentStatementAst"
	$description = "Obfuscate AssignmentStatementAst nodes"
	$example = 'Rename e.g. $Example = "Example" --> Set-Variable -Name Example -Value ("Example")'
	
	[string] getName(){
		return $this.name
	}
		[string] getExample(){
		return $this.example
	}
		[string] getDescription(){
		return $this.description
	}
	[string] run([string]$source){
	    $res = Out-ObfuscatedAst -ScriptString $source -AstTypesToObfuscate System.Management.Automation.Language.AssignmentStatementAst
		
		return $res
	}
}
class Transform_Ast_TypeExpressionAst:Transform{
	$name = "Ast_TypeExpressionAst"
	$description = "Obfuscate TypeExpressionAst nodes"
	$example = 'Rename e.g. [ScriptBlock] --> [Management.Automation.ScriptBlock]'
	
	[string] getName(){
		return $this.name
	}
		[string] getExample(){
		return $this.example
	}
		[string] getDescription(){
		return $this.description
	}
	[string] run([string]$source){
	    $res = Out-ObfuscatedAst -ScriptString $source -AstTypesToObfuscate System.Management.Automation.Language.TypeExpressionAst
		
		return $res
	}
}
class Transform_Ast_TypeConstraintAst:Transform{
	$name = "Ast_TypeConstraintAst"
	$description = "Obfuscate TypeConstraintAst nodes"
	$example = 'Rename e.g. [Int] $Integer = 1 --> [System.Int32] $Integer = 1'
	
	[string] getName(){
		return $this.name
	}
		[string] getExample(){
		return $this.example
	}
		[string] getDescription(){
		return $this.description
	}
	[string] run([string]$source){
	    $res = Out-ObfuscatedAst -ScriptString $source -AstTypesToObfuscate System.Management.Automation.Language.TypeConstraintAst
		
		return $res
	}
}
class Transform_Ast_ALL:Transform{
	$name = "Ast_ALL"
	$description = "Obfuscate ALL nodes"
	$example = 'Execute ALL Ast obfuscation techniques'
	
	[string] getName(){
		return $this.name
	}
		[string] getExample(){
		return $this.example
	}
		[string] getDescription(){
		return $this.description
	}
	[string] run([string]$source){
	    $res = Out-ObfuscatedAst -ScriptString $source
		return $res
	}
}
class Transform_Encode_Ascii:Transform{
	$name = "Encode_Ascii"
	$description = "Encode entire command as ASCII"
	$example = 'Source as an ASCII payload'
	[string] getName(){
		return $this.name
	}
		[string] getExample(){
		return $this.example
	}
		[string] getDescription(){
		return $this.description
	}
	[string] run([string]$source){
		$sb = [ScriptBlock]::Create($source)
		$res= Out-EncodedAsciiCommand -ScriptBlock $sb -NoProfile -NonInteractive -PassThru
		return $res
	}
}
class Transform_Encode_Hex:Transform{
	$name = "Encode_Hex"
	$description = "Encode entire command as Hex"
	$example = 'Source as a hex payload'
	[string] getName(){
		return $this.name
	}
		[string] getExample(){
		return $this.example
	}
		[string] getDescription(){
		return $this.description
	}
	[string] run([string]$source){
		$sb = [ScriptBlock]::Create($source)
		$res= Out-EncodedHexCommand -ScriptBlock $sb -NoProfile -NonInteractive -PassThru
		return $res
	}
}
class Transform_Encode_Octal:Transform{
	$name = "Encode_Octal"
	$description = "Encode entire command as Octal"
	$example = 'Source as an octal'
	[string] getName(){
		return $this.name
	}
		[string] getExample(){
		return $this.example
	}
		[string] getDescription(){
		return $this.description
	}
	[string] run([string]$source){
		$sb = [ScriptBlock]::Create($source)
		$res= Out-EncodedOctalCommand -ScriptBlock $sb -NoProfile -NonInteractive -PassThru
		return $res
	}
}
class Transform_Encode_Binary:Transform{
	$name = "Encode_Binary"
	$description = "Encode entire command as Binary"
	$example = 'Source as a binary'
	[string] getName(){
		return $this.name
	}
		[string] getExample(){
		return $this.example
	}
		[string] getDescription(){
		return $this.description
	}
	[string] run([string]$source){
		$sb = [ScriptBlock]::Create($source)
		$res= Out-EncodedBinaryCommand -ScriptBlock $sb -NoProfile -NonInteractive -PassThru
		return $res
	}
}
class Transform_Encode_SecureString_AES:Transform{
	$name = "Encode_SecureString_AES"
	$description = "Encrypt entire command as SecureString (AES)"
	$example = 'Source encripts by AES'
	[string] getName(){
		return $this.name
	}
		[string] getExample(){
		return $this.example
	}
		[string] getDescription(){
		return $this.description
	}
	[string] run([string]$source){
		$sb = [ScriptBlock]::Create($source)
		$res= Out-SecureStringCommand  -ScriptBlock $sb -NoProfile -NonInteractive -PassThru
		return $res
	}
}
class Transform_Encode_BXOR:Transform{
	$name = "Encode_BXOR"
	$description = "Encode entire command as an bitwise XOR'd payload"
	$example = 'Source encripts by BXOR'
	[string] getName(){
		return $this.name
	}
		[string] getExample(){
		return $this.example
	}
		[string] getDescription(){
		return $this.description
	}
	[string] run([string]$source){
		$sb = [ScriptBlock]::Create($source)
		$res= Out-EncodedBXORCommand  -ScriptBlock $sb -NoProfile -NonInteractive -PassThru
		return $res
	}
}
class Transform_Encode_SpecialCharactersOnly:Transform{
	$name = "Encode_SpecialCharactersOnly"
	$description = "Encode entire command as Special Characters"
	$example = 'Source contains only Special Characters'
	[string] getName(){
		return $this.name
	}
		[string] getExample(){
		return $this.example
	}
		[string] getDescription(){
		return $this.description
	}
	[string] run([string]$source){
		$sb = [ScriptBlock]::Create($source)
		$res= Out-EncodedSpecialCharOnlyCommand -ScriptBlock $sb -NoProfile -NonInteractive -PassThru
		return $res
	}
}
class Transform_Encode_EncodedWhitespaceCommand:Transform{
	$name = "Encode_EncodedWhitespaceCommand"
	$description = "Encode entire command as Whitespace"
	$example = 'Source as a Whitespace-and-Tab encoded payload'
	[string] getName(){
		return $this.name
	}
		[string] getExample(){
		return $this.example
	}
		[string] getDescription(){
		return $this.description
	}
	[string] run([string]$source){
		$sb = [ScriptBlock]::Create($source)
		$res= Out-EncodedWhitespaceCommand -ScriptBlock $sb -NoProfile -NonInteractive -PassThru
		return $res
	}
}
class Transform_Encode_Compress_IOCompression:Transform{
	$name = "Compress_IOCompression"
	$description = "Compress source with IO.Compression"
	$example = 'Convert entire command to one-liner and compress'
	[string] getName(){
		return $this.name
	}
		[string] getExample(){
		return $this.example
	}
		[string] getDescription(){
		return $this.description
	}
	[string] run([string]$source){
		$sb = [ScriptBlock]::Create($source)
		$res= Out-CompressedCommand  -ScriptBlock $sb -NoProfile -NonInteractive -PassThru
		return $res
	}
}
class Transform_Compress_CommandletToAliase:Transform{
	$name = "Compress_replaseCommandlet"
	$description = "Replase long commnadlet to short "
	$example = 'Move-Item -> mv'
	[string] getName(){
		return $this.name
	}
		[string] getExample(){
		return $this.example
	}
		[string] getDescription(){
		return $this.description
	}
	[string] run([string]$source){
	    #[Collections.Generic.LinkedList[String]] $comandlet = [Collections.Generic.LinkedList[String]]::new()
		#[hashtable] $aliases = [hashtable]::new()

		$aliases = @{ }
		$aliases.add("Add-Content","ac");
		$aliases.add("Add-PSSnapin","asnp");
		$aliases.add("Clear-Content","clc");
		$aliases.add("Clear-History","clhy");
		$aliases.add("clear","cls");
		$aliases.add("Clear-Host","cls");
		$aliases.add("Clear-Item","cli");
		$aliases.add("Clear-ItemProperty","clp");
		$aliases.add("Clear-Variable","clv");
		$aliases.add("compare","diff");
		$aliases.add("Compare-Object","diff");
		$aliases.add("Connect-PSSession","cnsn");
		$aliases.add("ConvertFrom-String3.1.0.0M","CFS");
		$aliases.add("Convert-Path","cvpa");
		$aliases.add("copy","cp");
		$aliases.add("Copy-Item","cp");
		$aliases.add("cpi","cp");
		$aliases.add("Copy-ItemProperty","cpp");
		$aliases.add("Disable-PSBreakpoint","dbp");
		$aliases.add("Disconnect-PSSession","dnsn");
		$aliases.add("Enable-PSBreakpoint","ebp");
		$aliases.add("Enter-PSSession","etsn");
		$aliases.add("Exit-PSSession","exsn");
		$aliases.add("Export-","epal");
		$aliases.add("Export-Csv","epcsv");
		$aliases.add("Export-PSSession","epsn");
		$aliases.add("ForEach-Object","%");
		#$aliases.add("foreach","%");
		$aliases.add("Format-Custom","fc");
		$aliases.add("Format-Hex3.1.0.0M","fhx");
		$aliases.add("Format-List","fl");
		$aliases.add("Format-Table","ft");
		$aliases.add("Format-Wide","fw");
		$aliases.add("Get-","gal");
		$aliases.add("dir","ls");
		$aliases.add("gci","ls");
		$aliases.add("Get-ChildItem","ls");
		$aliases.add("Get-Clipboard3.1.0.0M","gcb");
		$aliases.add("Get-Command","gcm");
		$aliases.add("Get-ComputerInfo3.1.0.0M","gin");
		$aliases.add("cat","gc");
		$aliases.add("Get-Content","gc");
		$aliases.add("type","gc");
		$aliases.add("ghy","h");
		$aliases.add("Get-History","h");
		$aliases.add("history","h");
		$aliases.add("Get-Item","gi");
		$aliases.add("Get-ItemProperty","gp");
		$aliases.add("Get-ItemPropertyValue","gpv");
		$aliases.add("Get-Job","gjb");
		$aliases.add("Get-Location","gl");
		$aliases.add("pwd","gl");
		$aliases.add("Get-Member","gm");
		$aliases.add("Get-Module","gmo");
		$aliases.add("gps","ps");
		$aliases.add("Get-Process","ps");
		$aliases.add("Get-PSBreakpoint","gbp");
		$aliases.add("Get-PSCallStack","gcs");
		$aliases.add("Get-PSDrive","gdr");
		$aliases.add("Get-PSSession","gsn");
		$aliases.add("Get-PSSnapin","gsnp");
		$aliases.add("Get-Service","gsv");
		$aliases.add("Get-TimeZone3.1.0.0M","gtz");
		$aliases.add("Get-Unique","gu");
		$aliases.add("Get-Variable","gv");
		$aliases.add("Get-WmiObject","gwmi");
		$aliases.add("Group-Object","group");
		$aliases.add("help","man");
		$aliases.add("Import-","ipal");
		$aliases.add("Import-Csv","ipcsv");
		$aliases.add("Import-Module","ipmo");
		$aliases.add("Import-PSSession","ipsn");
		$aliases.add("Invoke-Command","icm");
		$aliases.add("Invoke-Expression","iex");
		$aliases.add("ihy","r");
		$aliases.add("Invoke-History","r");
		$aliases.add("Invoke-Item","ii");
		$aliases.add("Invoke-RestMethod","irm");
		$aliases.add("curl","iwr");
		$aliases.add("Invoke-WebRequest","iwr");
		$aliases.add("wget","iwr");
		$aliases.add("Invoke-WmiMethod","iwmi");
		$aliases.add("Measure-Object","measure");
		$aliases.add("mkdir","md");
		$aliases.add("move","mv");
		$aliases.add("Move-Item","mv");
		$aliases.add("Move-ItemProperty","mp");
		$aliases.add("New-","nal");
		$aliases.add("New-Item","ni");
		$aliases.add("New-Module","nmo");
		$aliases.add("mount","ndr");
		$aliases.add("New-PSDrive","ndr");
		$aliases.add("New-PSSession","nsn");
		$aliases.add("New-PSSessionConfigurationFile","npssc");
		$aliases.add("New-Variable","nv");
		$aliases.add("Out-GridView","ogv");
		$aliases.add("Out-Host","oh");
		$aliases.add("Out-Printer","lp");
		$aliases.add("Pop-Location","popd");
		$aliases.add("powershell_ise.exe","ise");
		$aliases.add("Push-Location","pushd");
		$aliases.add("Receive-Job","rcjb");
		$aliases.add("Receive-PSSession","rcsn");
		$aliases.add("del","rm");
		$aliases.add("erase","rm");
		$aliases.add("Remove-Item","rm");
		$aliases.add("rmdir","rm");
		$aliases.add("Remove-ItemProperty","rp");
		$aliases.add("Remove-Job","rjb");
		$aliases.add("Remove-Module","rmo");
		$aliases.add("Remove-PSBreakpoint","rbp");
		$aliases.add("Remove-PSDrive","rdr");
		$aliases.add("Remove-PSSession","rsn");
		$aliases.add("Remove-PSSnapin","rsnp");
		$aliases.add("Remove-Variable","rv");
		$aliases.add("Remove-WmiObject","rwmi");
		$aliases.add("Rename-Item","ren");
		$aliases.add("Rename-ItemProperty","rnp");
		$aliases.add("Resolve-Path","rvpa");
		$aliases.add("Resume-Job","rujb");
		$aliases.add("Select-Object","select");
		$aliases.add("Select-String","sls");
		$aliases.add("Set-","sal");
		$aliases.add("Set-Clipboard3.1.0.0M","scb");
		$aliases.add("Set-Content","sc");
		$aliases.add("Set-Item","si");
		$aliases.add("Set-ItemProperty","sp");
		$aliases.add("Set-Location","cd");
		$aliases.add("chdir","cd");
		$aliases.add("Set-PSBreakpoint","sbp");
		$aliases.add("Set-TimeZone3.1.0.0M","stz");
		$aliases.add("set","sv");
		$aliases.add("Set-Variable","sv");
		$aliases.add("Set-WmiInstance","swmi");
		$aliases.add("Show-Command","shcm");
		$aliases.add("Sort-Object","sort");
		$aliases.add("Start-Job","sajb");
		$aliases.add("start","saps");
		$aliases.add("Start-Process","saps");
		$aliases.add("Start-Service","sasv");
		$aliases.add("Start-Sleep","sleep");
		$aliases.add("Stop-Job","spjb");
		$aliases.add("Stop-Process","kill");
		$aliases.add("Stop-Service","spsv");
		$aliases.add("Suspend-Job","sujb");
		$aliases.add("Tee-Object","tee");
		$aliases.add("Trace-Command","trcm");
		$aliases.add("Wait-Job","wjb");
		$aliases.add("Where-Object","?");
		$aliases.add("where","?");
		$aliases.add("Write-Output","echo");
		$aliases.add("write","echo");
		$key_large =$aliases.Keys;
		$res = $source
		foreach ($k in $key_large){
		#$res	= $res.Replace($k,$aliases[$k])
		$rep =  $aliases[$k]+" "

		$res= 	$res -ireplace [regex]::Escape($k+" "),$rep
		}

		
		return $res
	}
}
class Transform_Compress_removeTrash:Transform{
	$name = "Compress_removeTrash"
	$description = "Compress source by remove \t \n space and other symbols"
	$example = ''
	[string] getName(){
		return $this.name
	}
		[string] getExample(){
		return $this.example
	}
		[string] getDescription(){
		return $this.description
	}
	[string] run([string]$source){

		$out = $source
		$out =[Regex]::Replace($out,"\}[ \r\n\t;]+\}","}}")
		$out =[Regex]::Replace($out," =","=")
		$out =[Regex]::Replace($out,"= ","=")
		$out =[Regex]::Replace($out,"\}[ \r\n\t;]+\}","}}")
		$out =[Regex]::Replace($out,"\}[ \r\n\t;]+\}","}}")
		$out =[Regex]::Replace($out,"\}[ \r\n\t;]+\}","}}")
		$out =[Regex]::Replace($out,"^[\t ]+","",[System.Text.RegularExpressions.RegexOptions]::Multiline)
		$out =[Regex]::Replace($out,"^[\n\r]+","",[System.Text.RegularExpressions.RegexOptions]::Multiline)
		$out =[Regex]::Replace($out,";;",";")
		return $out

		$res = ""
		$isString  = $false
		$isSpace  = $false
		$ch = $out.ToCharArray()
		foreach($c in $ch)
		{
			if($c -eq '"'){
			$isString = !$isString
				}
		    if(!$isString){
						if($c -eq '\t'){
						$c = ' '}

						}
		    if($c -eq ' '){
						if (!$isSpace){
							$isSpace = $true
							$res+=$c
							continue 
						}
					}else{
					$isSpace = $false
					}
			if ($isString){
				$res+=$c
			}else{
				if(!$isSpace)
				{
					$res+=$c
				}
			}
		}

	
		return $res
	}
}
class Transform_Rename_variables:Transform{
	$name = "Rename_variables"
	$description = "Rename all variables (do not use for class and function param (use position))"
	$example = '$varriable = 1234 - >  $a = 1234'
	[string] getName(){
		return $this.name
	}
		[string] getExample(){
		return $this.example
	}
		[string] getDescription(){
		return $this.description
	}
	[string] run([string]$source){
		$sb = [ScriptBlock]::Create($source)
		$res = OfsVariables -ScriptBlock $sb
		return $res
	}
}
class Transform_escapeDollar:Transform{
	$name = 'Escape$'
	$description = ' $ -> `$'
	$example = '$var -> `$var'
	[string] getName(){
		return $this.name
	}
		[string] getExample(){
		return $this.example
	}
		[string] getDescription(){
		return $this.description
	}
	[string] run([string]$source){
		$res = $source.Replace('$','`$')
		return $res
	}
}
class Transform_chq:Transform{
	$name = 'Change_quotes'
	$description = ' " -> '''
	$example = ' "val" -> ''val'''
	[string] getName(){
		return $this.name
	}
		[string] getExample(){
		return $this.example
	}
		[string] getDescription(){
		return $this.description
	}
	[string] run([string]$source){
		$res = $source.Replace("""",'''')
		return $res
	}
}
class Transform_toOneLine:Transform{
	$name = "ToOneLine"
	$description = "Convert script to valid one line command"
	$example = '{echo ok 
echo error} > {echo ok ;echo error} '
	[string] getName(){
		return $this.name
	}
		[string] getExample(){
		return $this.example
	}
		[string] getDescription(){
		return $this.description
	}
	[string] run([string]$source){
		$sb = [ScriptBlock]::Create($source)
		$res = toOneLine -ScriptBlock $sb
		return $res
	}
}
class Transform_toOneLine2:Transform{
	$name = "ToOneLine2"
	$description = "Convert script to valid one line command. Using multiple iteration"
	$example = '{echo ok 
echo error} > {echo ok ;echo error} '
	[string] getName(){
		return $this.name
	}
		[string] getExample(){
		return $this.example
	}
		[string] getDescription(){
		return $this.description
	}
	[string] run([string]$source){
		$sb = [ScriptBlock]::Create($source)
		$res = toOneLine2 -ScriptBlock $sb
		return $res
	}
}
#############------------TRANSFORMS---------------------------

class TransformStorage{
		[Collections.Generic.LinkedList[Transform]] $TransformList = [Collections.Generic.LinkedList[Transform]]::new()
		TransformStorage(){
			$this.registration()
		}
		[void] registration(){
		[Transform_DelimitedAndConcatenated] $trs = [Transform_DelimitedAndConcatenated]::new()
			$this.TransformList.Add($trs)
		[Transform_DelimitedConcatenatedAndReordered]$trs = [Transform_DelimitedConcatenatedAndReordered]::new()
			$this.TransformList.Add($trs)
		[Transform_StringReversed]$trs = [Transform_StringReversed]::new()
			$this.TransformList.Add($trs)
		[Transform_TokenCommand_Strin1]$trs = [Transform_TokenCommand_Strin1]::new()
			$this.TransformList.Add($trs)
		[Transform_TokenCommand_Strin2]$trs = [Transform_TokenCommand_Strin2]::new()
			$this.TransformList.Add($trs)
		[Transform_TokenCommand_Command1]$trs = [Transform_TokenCommand_Command1]::new()
			$this.TransformList.Add($trs)
		[Transform_TokenCommand_Command2]$trs = [Transform_TokenCommand_Command2]::new()
			$this.TransformList.Add($trs)
		[Transform_TokenCommand_Command3]$trs = [Transform_TokenCommand_Command3]::new()
			$this.TransformList.Add($trs)
		[Transform_TokenCommand_Argument1]$trs = [Transform_TokenCommand_Argument1]::new()
			$this.TransformList.Add($trs)
		[Transform_TokenCommand_Argument2]$trs = [Transform_TokenCommand_Argument2]::new()
			$this.TransformList.Add($trs)
		[Transform_TokenCommand_Argument3]$trs = [Transform_TokenCommand_Argument3]::new()
			$this.TransformList.Add($trs)
		[Transform_TokenCommand_Argument4]$trs = [Transform_TokenCommand_Argument4]::new()
			$this.TransformList.Add($trs)
		[Transform_TokenCommand_Member1]$trs = [Transform_TokenCommand_Member1]::new()
			$this.TransformList.Add($trs)
		[Transform_TokenCommand_Member2]$trs = [Transform_TokenCommand_Member2]::new()
			$this.TransformList.Add($trs)
		[Transform_TokenCommand_Member3]$trs = [Transform_TokenCommand_Member3]::new()
			$this.TransformList.Add($trs)
		[Transform_TokenCommand_Member4]$trs = [Transform_TokenCommand_Member4]::new()
			$this.TransformList.Add($trs)
		[Transform_TokenCommand_Variable1]$trs = [Transform_TokenCommand_Variable1]::new()
			$this.TransformList.Add($trs)
		[Transform_TokenCommand_Type1]$trs = [Transform_TokenCommand_Type1]::new()
			$this.TransformList.Add($trs)
		[Transform_TokenCommand_Type2]$trs = [Transform_TokenCommand_Type2]::new()
			$this.TransformList.Add($trs)
		[Transform_TokenCommand_Comment1]$trs = [Transform_TokenCommand_Comment1]::new()
			$this.TransformList.Add($trs)
		[Transform_TokenCommand_WhiteSpace1]$trs = [Transform_TokenCommand_WhiteSpace1]::new()
			$this.TransformList.Add($trs)
		[Transform_TokenCommand_All]$trs = [Transform_TokenCommand_All]::new()
			$this.TransformList.Add($trs)
		[Transform_Ast_NamedAttributeArgumentAst]$trs = [Transform_Ast_NamedAttributeArgumentAst]::new()
			$this.TransformList.Add($trs)
		[Transform_Ast_ParamBlockAst]$trs = [Transform_Ast_ParamBlockAst]::new()
			$this.TransformList.Add($trs)
		[Transform_Ast_ScriptBlockAst]$trs = [Transform_Ast_ScriptBlockAst]::new()
			$this.TransformList.Add($trs)
		[Transform_Ast_AttributeAst]$trs = [Transform_Ast_AttributeAst]::new()
			$this.TransformList.Add($trs)
		[Transform_Ast_BinaryExpressionAst]$trs = [Transform_Ast_BinaryExpressionAst]::new()
			$this.TransformList.Add($trs)
		[Transform_Ast_HashtableAst]$trs = [Transform_Ast_HashtableAst]::new()
			$this.TransformList.Add($trs)
		[Transform_Ast_CommandAst]$trs = [Transform_Ast_CommandAst]::new()
			$this.TransformList.Add($trs)
		[Transform_Ast_AssignmentStatementAst]$trs = [Transform_Ast_AssignmentStatementAst]::new()
			$this.TransformList.Add($trs)	
		[Transform_Ast_TypeExpressionAst]$trs = [Transform_Ast_TypeExpressionAst]::new()
			$this.TransformList.Add($trs)		
		[Transform_Ast_TypeConstraintAst]$trs = [Transform_Ast_TypeConstraintAst]::new()
			$this.TransformList.Add($trs)			
		[Transform_Ast_ALL]$trs = [Transform_Ast_ALL]::new()
			$this.TransformList.Add($trs)		
		[Transform_Encode_Ascii]$trs = [Transform_Encode_Ascii]::new()
			$this.TransformList.Add($trs)	
		[Transform_Encode_Hex]$trs = [Transform_Encode_Hex]::new()
			$this.TransformList.Add($trs)	
		[Transform_Encode_Octal]$trs = [Transform_Encode_Octal]::new()
			$this.TransformList.Add($trs)		
		[Transform_Encode_SecureString_AES]$trs = [Transform_Encode_SecureString_AES]::new()
			$this.TransformList.Add($trs)	
		[Transform_Encode_BXOR]$trs = [Transform_Encode_BXOR]::new()
			$this.TransformList.Add($trs)		
		[Transform_Encode_SpecialCharactersOnly]$trs = [Transform_Encode_SpecialCharactersOnly]::new()
			$this.TransformList.Add($trs)		
		[Transform_Encode_EncodedWhitespaceCommand]$trs = [Transform_Encode_EncodedWhitespaceCommand]::new()
			$this.TransformList.Add($trs)	
		[Transform_Rename_variables]$trs = [Transform_Rename_variables]::new()
			$this.TransformList.Add($trs)	
		[Transform_Encode_Compress_IOCompression]$trs = [Transform_Encode_Compress_IOCompression]::new()
			$this.TransformList.Add($trs)
		[Transform_Compress_CommandletToAliase]$trs = [Transform_Compress_CommandletToAliase]::new()
			$this.TransformList.Add($trs)	
		[Transform_Compress_removeTrash]$trs = [Transform_Compress_removeTrash]::new()
			$this.TransformList.Add($trs)	
		[Transform_toOneLine]$trs = [Transform_toOneLine]::new()
			$this.TransformList.Add($trs)
		[Transform_toOneLine2]$trs = [Transform_toOneLine2]::new()
			$this.TransformList.Add($trs)	
		[Transform_escapeDollar]$trs = [Transform_escapeDollar]::new()
			$this.TransformList.Add($trs)	
		[Transform_chq]$trs = [Transform_chq]::new()
			$this.TransformList.Add($trs)	
	
		}

		[Transform] getTransformbyName([string]$tname){ 
		ForEach($s in $this.TransformList){
			if ($s.getName() -eq $tname){
				return $s	
					}
				}
			return $null
		}

		[Collections.Generic.LinkedList[Transform]] getDefaultTransformSet(){
		[Collections.Generic.LinkedList[Transform]] $default = [Collections.Generic.LinkedList[Transform]]::new()
		[Transform_TokenCommand_Comment1]$trs = [Transform_TokenCommand_Comment1]::new()
		$default.Add($trs)
		[Transform_Compress_removeTrash]$trs = [Transform_Compress_removeTrash]::new()
		$default.Add($trs)
		return $default
		}
}

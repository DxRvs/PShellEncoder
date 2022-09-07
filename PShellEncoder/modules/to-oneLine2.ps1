<#TODO
function -paramname
$string = "ad$variablesxz"
#>

Function toOneLine2{
	Param (
        [ScriptBlock] $ScriptBlock,
		[int] $skip =0
	)
	
	while ($true){
	[string] $script =$ScriptBlock.ToString()
	$scriptchar =$script.ToCharArray()
	 $index = New-Object System.Collections.ArrayList


	$Tokens = [System.Management.Automation.PSParser]::Tokenize($ScriptBlock,[ref]$null)
	For($i=0; $i -lt $Tokens.Count ;$i++ )
	  {
        [System.Management.Automation.PSToken]  $Token = $Tokens[$i]
    	If($Token.Type -eq [System.Management.Automation.PSTokenType]::NewLine) {
		$index.Add($Token.Start) |Out-Null
		}
	  }
	if ($index.Count - $skip  -eq 1){
		$sc = $ScriptBlock.ToString().Replace(";;",";").Replace(";;",";")
		return [ScriptBlock]::Create($sc)
	}

	[string] $result = ""
	[string] $pref = ""
	[string] $suff = ""
	for($i =0; $i -lt $scriptchar.Length; $i++){
			if (!$index.Contains($i)){
			$pref+=$scriptchar[$i]
			}else{
				$result+=$add
				$i++
				for ($j=$i; $j -lt $scriptchar.Length;$j++){
				$suff+=$scriptchar[$j]
				}
				break
			}
	}
	$variant = @(";",""," ")
	$resultScript =$null
	foreach($repl in $variant){
	$result= $pref+$repl+$suff
		try
		{$resultScript = [ScriptBlock]::Create($result)
			break
		}
		catch{
			$resultScript = $null
			}
		}
	if ($resultScript -eq $null){
		$skip = $skip+1 
		}else{
			$ScriptBlock = $resultScript
		}
	}
}

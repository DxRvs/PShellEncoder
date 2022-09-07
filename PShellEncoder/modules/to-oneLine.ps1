<#TODO
function -paramname
$string = "ad$variablesxz"
#>

Function toOneLine{
	Param (
        [ScriptBlock] $ScriptBlock
	)
	
	[string] $script =$ScriptBlock.ToString()
	$scriptchar =$script.ToCharArray()
	 $index = New-Object System.Collections.ArrayList


	$Tokens = [System.Management.Automation.PSParser]::Tokenize($ScriptBlock,[ref]$null)
	$newLines=@{}
	For($i=0; $i -lt $Tokens.Count ;$i++ )
	  {
        [System.Management.Automation.PSToken]  $Token = $Tokens[$i]
    	If($Token.Type -eq [System.Management.Automation.PSTokenType]::NewLine) {

		$index.Add($Token.Start) |Out-Null

		if($i -gt 0){
			$in = $Token.Start

		$newLines.Add($in,$Tokens[$i-1]) 
		}
		if($i -lt $Tokens.Count ){
		$in = $Token.Start+1
			
			$newLines.Add($in,$Tokens[$i+1]) 
		}
		}

		
	  }
	[string] $result = ""
	for($i =0; $i -lt $scriptchar.Length; $i++){
		if (!$index.Contains($i)){
			$result+=$scriptchar[$i]
		}else{
			$add= ""
			$preftoken = $newLines.$i
			if($preftoken -ne $null){
				# , -> operator
				if(($preftoken.Type -eq [System.Management.Automation.PSTokenType]::GroupStart) -or ($preftoken.Content -eq ",") -or ($preftoken.Type -eq [System.Management.Automation.PSTokenType]::CommandArgument) ){
					$add= ""

				}else{
					$add=";"
				}

			}else{
				$add=";"
			}
			$n = $i+1
			$suftoken = $newLines.$n
			if($suftoken -ne $null){
				if (($suftoken.Type -eq [System.Management.Automation.PSTokenType]::GroupEnd) -or  ($suftoken.Type -eq [System.Management.Automation.PSTokenType]::GroupStart)){
					$add=""
				}
				#if($suftoken.Type -eq [System.Management.Automation.PSTokenType]::Keyword){
				#$add=";"
				#}
			}
			$result+=$add
			$i++;
		}
	}



	return $result
	

}

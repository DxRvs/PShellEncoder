<#TODO
function -paramname
$string = "ad$variablesxz"
#>

function  getVarName{
	Param ([int] $index)
	[char] $let =[char] ($index%26 + 97)

	$crindex = $index
	$count=0
	while($crindex -ge 26){
		$crindex = $crindex - 26
		$count+=1
		}
	if($count -gt 0 ){
		$res =getVarName -index ($count-1)
		$res =$let + $res
		return $res
		}
	return $let
}
Function OfsVariables{
	Param (
        [ScriptBlock] $ScriptBlock
	)
	$systemsvar=@("psversiontable","true","this","false","evn","script","_","null","error","global")
	$systemsdifvar=@("global:","script:")
	$variablse =@{}
	$Tokens = [System.Management.Automation.PSParser]::Tokenize($ScriptBlock,[ref]$null)

	    For($i=$Tokens.Count-1; $i -ge 0; $i--)
		  {
			  
      [System.Management.Automation.PSToken]  $Token = $Tokens[$i]
		 
		If($Token.Type -eq [System.Management.Automation.PSTokenType]::Variable) 
			{
			if(!$systemsvar.Contains($Token.Content.ToLower())){
				$dificult = $false
				foreach($v in $systemsdifvar){
				if($Token.Content.ToLower().Contains($v)){
					$dificult= $true
					}
				}
				if ($dificult){
				continue
				}
				if($variablse.Contains($Token.Content.ToLower())){
					$name = $Token.Content.ToLower()
					$variablse.$name += $Token
				}else{

					$variablse.Add($Token.Content.ToLower(),@($Token))
					}
			}
				
		}
	}
	
	$variablse = $variablse.GetEnumerator() | sort { $_.Name.length } 
	
	if(!$variablse){
		$variablse=@()
	}


	if($variablse.gettype().Name -eq "DictionaryEntry"){#trable
		$variablse=@($variablse)
	}
	
	$count =0;
	$script =$ScriptBlock.ToString()
	$shifts = New-Object int[] $script.Length
	WRITE-HOST "Variables count for replace:" $variablse.Count
	foreach($tks in $variablse.GetEnumerator() ){

			
		foreach($tk in $tks.value){
		  $newvar = getVarName -index $count
		  $oldvar = $tk.Content
		  $oldvar="$"+$oldvar
     	  $newvar="$"+$newvar
		  Write-Host  ($oldvar + " -> " + $newvar)
		  $left = $script.Substring(0,$tk.Start+$shifts[$tk.Start])

		  $right= $script.Substring($tk.Start+$shifts[$tk.Start]+$oldvar.Length,$script.Length - $tk.Start-$shifts[$tk.Start] - $oldvar.Length)

		  $script = $left+$newvar+$right
          $shift =  $newvar.Length -$oldvar.Length
			if($shift -ne 0 ){

				for($i=$tk.start+$oldvar.Length; $i -lt $shifts.Length;$i++){
					$shifts[$i]+=$shift
					}
				
				}
			
			}

	$count+=1	
	}
	
	return $script
}


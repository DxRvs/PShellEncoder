### Invoke-Obfuscation functions

Class SScript{
	[string] $Name
	[System.Collections.ArrayList] $Category
	[string] $Description
	[string] $Source
	
	[string] toString(){
	return $this.Name+"   ["+$this.Description+"]"
	}

	SScript([string]$script_name){
		$this.Name = $script_name
		$this.Category = New-Object -TypeName "System.Collections.ArrayList"
	}
}
Class ScriptStorage{
	[String] $catInformation="Information"
	[String] $catNetwork="Network"
	[String] $catManagment="Managment"
	[String] $catSystem="System"
	[String] $catUtils="Utils"
	[String] $catCustom="Custom"
	[String] $_catALL="ALL"
	[Collections.Generic.LinkedList[SScript]] $ScriptList = [Collections.Generic.LinkedList[SScript]]::new()
	[String[]] $ListCat =<#_ListCat_#>($this._catALL)<#_ListCat_#>
	static  [string] encodeBase64($text){
		try{
	$Bytes = [System.Text.Encoding]::Unicode.GetBytes($text)
	$EncodedText =[Convert]::ToBase64String($Bytes)
		return $EncodedText
			}catch{
				$ErrorMessage = $_.Exception.Message
				Write-Error $ErrorMessage

			return ""
			}
	}
	static 	[string] decodeBase64($text){
			try{return [System.Text.Encoding]::Unicode.GetString([System.Convert]::FromBase64String($text))}
			catch{
				$ErrorMessage = $_.Exception.Message
				
				Write-Error $ErrorMessage
			return ""
			}
	}

	ScriptStorage(){
			$this.buildScript()
		}


	[SScript] getScript([string]$sdesc){ #!! toString()
		ForEach($s in $this.ScriptList){
			if ($s.toString() -eq $sdesc){
				return $s	
				}
		}
		return $null
	}

	[SScript] getScriptbyName([string]$sname){ #!! toString()
		ForEach($s in $this.ScriptList){
			if ($s.Name -eq $sname){
				return $s	
				}
		}
		return $null
	}
	[Collections.Generic.LinkedList[SScript]]getScripyByCaterory([String]$catName){

		if ($catName -eq $this._catALL){
			return $this.ScriptList
			}
		[Collections.Generic.LinkedList[SScript]] $catscr = [Collections.Generic.LinkedList[SScript]]::new()
		foreach( $s in $this.ScriptList){
			foreach($cat in $s.Category ){
					if ($cat -eq $catName){
						$catscr.Add($s)
					}
				}
		}

		return $catscr
	}


	[void] buildScript(){
<#_buildScript_#>
<#_buildScript_#>
	}
}

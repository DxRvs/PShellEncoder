### Init build enviroment
$pathSep = [IO.Path]::DirectorySeparatorChar
$buildPatch=$PSScriptRoot+$pathSep+"build"+$pathSep
if (-not (Test-Path $buildPatch)){
	mkdir $buildPatch
}

. ($PSScriptRoot+$pathSep+"PSEncoderWorker.ps1")

function GetCorrectStringEncoding($bytes){
    # Analyze the BOM
	# return Encoding.UTF7;EF BB BF
    if ($bytes[0] -eq 0x2b -and $bytes[1] -eq 0x2f -and $bytes[2] -eq 0x76)
	{
		#Write-Host "UTF7"
		return  [System.Text.Encoding]::UTF7.GetString($bytes)
	}
	# return Encoding.UTF8;
    if ($bytes[0] -eq 0xef -and $bytes[1] -eq 0xbb -and $bytes[2] -eq 0xbf){
		#Write-Host "UTF8"
		return  [System.Text.Encoding]::UTF8.GetString($bytes)
	}
	# return Encoding.Unicode; //UTF-16LE
    if ($bytes[0] -eq 0xff -and $bytes[1] -eq 0xfe){
		#Write-Host "UTF-16LE"
		return  [System.Text.Encoding]::Unicode.GetString($bytes)
	}
	# return Encoding.BigEndianUnicode; //UTF-16BE
    if ($bytes[0] -eq 0xfe -and $bytes[1] -eq 0xff){
		#Write-Host "UTF-16BE"
		return  [System.Text.Encoding]::BigEndianUnicode.GetString($bytes)
	}
	# return Encoding.UTF32;
    if ($bytes[0] -eq 0 -and $bytes[1] -eq 0 -and $bytes[2] -eq 0xfe -and $bytes[3] -eq 0xff){
		#Write-Host "UTF-32"
		return  [System.Text.Encoding]::UTF32.GetString($bytes)
	}
	#Write-Host "UTF-8"

    return [System.Text.Encoding]::UTF8.GetString($bytes)
}

function changeVierion([String]$VERSION,$outName){
[String] $mainscript
$bytes = [System.IO.File]::ReadAllBytes($buildPatch+$outName)
$mainscript = GetCorrectStringEncoding($bytes)
$pattern_version="<#_version_#>.+?<#_version_#>"
$mainscript = [regex]::Replace($mainscript,$pattern_version,"<#_version_#>`""+$VERSION+"`"<#_version_#>")
$byteMainScript = [System.Text.Encoding]::UTF8.GetBytes($mainscript)
if($byteMainScript[0] -eq 0xef){
if($byteMainScript[1] -eq 0xbb){
if($byteMainScript[2] -eq 0xbf){
	$ln = $byteMainScript.length -3
	 $result =  new-object byte[] $ln
	[Array]::Copy($byteMainScript, 3, $result, 0, $ln)
	$byteMainScript = $result
}
}
}

[System.IO.File]::WriteAllBytes($buildPatch+$outName,$byteMainScript)
}

function _scriptTree($scPath){
	$elements = ls $scPath -Recurse
	[Collections.Generic.LinkedList[System.IO.FileSystemInfo]] $scripts= [Collections.Generic.LinkedList[System.IO.FileSystemInfo]]::new()
	foreach($element in $elements){
		[System.IO.FileSystemInfo] $finfo = $element
		if($finfo.Extension.ToUpper() -eq ".PS1" ){
		$scripts.Add($finfo)
		}
	}
	return $scripts
}

function sortByIndex([System.Text.RegularExpressions.MatchCollection] $collections){
	[Collections.Generic.List[System.Text.RegularExpressions.Match]] $newColl = [Collections.Generic.List[System.Text.RegularExpressions.Match]]::new()
	foreach($includ in $collections){
		$newColl.Add($includ)
	}
	$newColl.Reverse()
	return $newColl
}

function getExternalScripts([String] $script){
	
	$bytes = [System.IO.File]::ReadAllBytes($script)
	#Write-Host $script.FullName
	[String] $mainscript = GetCorrectStringEncoding($bytes)
	$pattern_include = "\. .+?ps1`"\)"
	[System.Text.RegularExpressions.MatchCollection] $collection = [regex]::Matches($mainscript,$pattern_include)
	if($collection.Count -gt 0){
		$sortedcollection = sortByIndex($collection);
	foreach($includ in $sortedcollection){
		$pattern_sname= "`".+?ps1"
		[System.Text.RegularExpressions.MatchCollection] $snames = [regex]::Matches($includ.value,$pattern_sname)
		
		if($snames.Count -eq 1){
			$full_sname=""
			$snames.ForEach({
				$p = $_.value.substring(1)
				[string] $part_n = $p.replace("\",$pathSep)
				if ($part_n -eq $p){
				[string] $part_n = $p.replace("/",$pathSep)
				}
				$full_sname = $PSScriptRoot+$pathSep + $part_n
			})
		$included_script=getExternalScripts ($full_sname)
		Write-Host "include " $full_sname
		$index =  ([System.Text.RegularExpressions.Match]$includ).Index
		$length =  ([System.Text.RegularExpressions.Match]$includ).Value.Length
		$resultmainscript = $mainscript.Substring(0,$index)+$included_script+$mainscript.Substring($index+$length,$mainscript.Length-$length-$index)
		$mainscript= $resultmainscript
		}

		}
		return $mainscript;
	}else{
		
		return $mainscript;
	}
}

function buildOneScript($mainscript,$outName){
	[string]$result = getExternalScripts($mainscript)
	$byteMainScript = [System.Text.Encoding]::UTF8.GetBytes($result)
	[System.IO.File]::WriteAllBytes($buildPatch+$outName,$byteMainScript)
}

function modScript($scr){
	return [PSEncoderWorker]::encodeBase64($scr)
}

function getScriptInfo($script){
	$pattern_desctiption="<description>.+?<description>"
	$pattern_categories="<categories>.+?<categories>"
	$desctiprion=""
	$categories=""
	$ScriptBlock = [ScriptBlock]::Create($script)
	$Tokens = [System.Management.Automation.PSParser]::Tokenize($ScriptBlock,[ref]$null)
		    For($i=$Tokens.Count-1; $i -ge 0; $i--)
		  {
		     [System.Management.Automation.PSToken]  $Token = $Tokens[$i]
				If($Token.Type -eq [System.Management.Automation.PSTokenType]::Comment) 
				{
					 [string]$comment= $script.SubString($Token.Start,$Token.Length)

					[System.Text.RegularExpressions.Match] $desk = [regex]::Match($comment,$pattern_desctiption,[System.Text.RegularExpressions.RegexOptions]::Singleline)
					if($desk.Success){
						$desctiprion = $desk.Value.Replace("<description>",'')
					}
					[System.Text.RegularExpressions.Match] $cat = [regex]::Match($comment,$pattern_categories,[System.Text.RegularExpressions.RegexOptions]::Singleline)
					if($cat.Success){
						$categories = $cat.Value.Replace("<categories>",'')
					}
				
			}
		  }
	return $desctiprion,$categories
}
function getScriptName([System.IO.FileSystemInfo] $pathFile){
	$pathFile.Name.Substring(0,$pathFile.Name.Length - $pathFile.Extension.Length)
}

function getCategories([string]$cat){
	$cat=$cat.Trim()
	$cat=$cat.Replace(' ','')
	$cats= $cat.Split(',')
	return $cats
}

function normalizeString([string] $text){
	$text = $text.Replace('"',"_")
	$text = $text.Replace('$',"_")
	return $text
}

function buildRawScript($rawPath){
	$result="`n"
	$categories=""
	if(Test-Path $rawPath){
		$rawlist = ls $rawPath -Recurse -Include "*.ps1"
		foreach($sc in $rawlist){
			$bytes = [System.IO.File]::ReadAllBytes($sc.FullName)
			$script = GetCorrectStringEncoding($bytes)
			$name = getScriptName($sc)
			$info = getScriptInfo($script)
			$modScript = modScript($script)
			$cats = getCategories($info[1])
			$result+='[SScript] $scr = [SScript]::new("'+$name+'")'+"`n"
			$d = normalizeString($info[0])
			$result+='$scr.Description="'+$d+'"'+"`n"
			$result+='$scr.Source=[ScriptStorage]::decodeBase64("'+$modScript+'")'+"`n"
			foreach($cat in $cats){
				if($cat.Length -gt 0){
				$categoryName=$cat.Substring(0,1).ToUpper()+$cat.Substring(1,$cat.Length-1)
					$result+='$scr.Category.Add("'+$categoryName+'")'+"`n"
				$categories+=$categoryName+","
				}
			}
			$result+='$this.ScriptList.Add($scr)'+"`n"
		}
	}
return $result,$categories
}

function changeScriptStorage($pathfile){
	$buldBody , $cats = buildRawScript ($PSScriptRoot+$pathSep+"scripts"+$pathSep+"raw")

	[String] $mainscript
	$bytes = [System.IO.File]::ReadAllBytes($pathfile)
	$mainscript = GetCorrectStringEncoding($bytes)
	$pattern_buildScript="<#_buildScript_#>"
	$startIndex = $mainscript.IndexOf($pattern_buildScript)
	$endIndex = $mainscript.LastIndexOf($pattern_buildScript)
	$mainscript=$mainscript.Substring(0,$startIndex+$pattern_buildScript.Length)+$buldBody+$mainscript.Substring($endIndex)

	$pattern_ListCat="<#_ListCat_#>"
	$startIndex = $mainscript.IndexOf($pattern_ListCat)
	$endIndex = $mainscript.LastIndexOf($pattern_ListCat)
	$categories = ([string]$cats).Split(',')
	$setCat = New-Object 'System.Collections.Generic.HashSet[string]'
	foreach($c in $categories  ){
		$setCat.Add($c)
	}
	
	$changecat='( '
	foreach($c in $setCat){
		if($c.Length -gt 0){
		$changecat+='"'+$c+'",'
		}
	}
	$changecat+='$this._catALL)'
	$mainscript=$mainscript.Substring(0,$startIndex+$pattern_ListCat.Length)+$changecat+$mainscript.Substring($endIndex)
	$byteMainScript = [System.Text.Encoding]::UTF8.GetBytes($mainscript)
	[System.IO.File]::WriteAllBytes($pathfile,$byteMainScript)
}
function defaultTransform($pathInp,$pathOut){
	$pt = $buildPatch+"PShellEncoder.ps1"
	if($Env:OS -ne $null) {
	if ($Env:OS.ToLower().Contains("windows")) {
	$cmd = "powershell.exe -file  `"$pt`" -nogui  -t `"TokenCommand_Comment1,Compress_IOCompression`" -sourceFile `"$pathInp`"  -outfile `"$pathOut`""
	Write-Host $cmd 
	cmd /c $cmd
	}else{
	$cmd = "pwsh -file  `"$pt`" -nogui  -t `"TokenCommand_Comment1,Compress_IOCompression`" -sourceFile `"$pathInp`"  -outfile `"$pathOut`""
	Write-Host $cmd 
	bash -c $cmd
	}
	}else{
	if ($isWindows -eq $false){
	$cmd = "pwsh -file  `"$pt`" -nogui  -t `"TokenCommand_Comment1,Compress_IOCompression`" -sourceFile `"$pathInp`"  -outfile `"$pathOut`""
	Write-Host $cmd 
	bash -c $cmd
	}else{
		Write-Host "unknown  OS"
	}
	}
}

changeScriptStorage ($PSScriptRoot+$pathSep+"ScriptStorage.ps1")
buildOneScript ($PSScriptRoot+$pathSep+"PSEncoderUI.ps1")  "PShellEncoder.ps1"
changeVierion "1.07b" "PShellEncoder.ps1"
defaultTransform($buildPatch+"PShellEncoder.ps1") ($buildPatch+"PShellEncoderEnc.ps1")

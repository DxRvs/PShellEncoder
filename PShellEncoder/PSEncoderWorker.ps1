Class PSEncoderWorker{
	[String]$LogFile=$null
	[Collections.Generic.LinkedList[String]] $Items
	$transforms
	[string] $sourcepowershellcode
	[scriptblock] $writelogCallBack

	PSEncoderWorker([String]$source,[Collections.Generic.LinkedList[String]] $list,$tStorage,[scriptblock]$writelogfunction){
	$this.Items = $list
    $this.transforms = $tStorage
	$this.sourcepowershellcode = $source
	$this.writelogCallBack = $writelogfunction
	$this.startLogs() 
	}

	[String] run(){
		$result= $this.sourcepowershellcode
		$this.Items.Count
		if($this.LogFile){
		$this.writeLog("Log FILE: " + $this.LogFile)
		Add-Content -Path $this.LogFile -Value "#------------------------------SOURCE-------------------------------"
		Add-Content -Path $this.LogFile -Value $result
		}
		foreach($trname in $this.Items){
		$tr = $this.transforms.getTransformbyName($trname)
		$this.writeLog("Runned: "+$tr.getName())
		
		try{

			$result = $tr.run($result)
			if($this.LogFile){
			$LOG = "#------------------------------"+$tr.getName()+"-------------------------------"
			Add-Content -Path $this.LogFile -Value $LOG
			Add-Content -Path $this.LogFile -Value $result
			}
		}Catch{
			$this.writeLog("ERROR!")
			Write-Host ([System.GC]::GetTotalMemory(0))
			$this.writeLog($_.Exception.ToString())
			    $this.writeLog($_.Exception.Message)
				$this.writeLog($_.Exception.ItemName)
		}
		$this.writeLog("Current Size: "+$result.Length)
		}
		$this.writeLog("--------------------------------------------------------------------")
		
	return $result
	}

	[void] writeLog([String] $text){
		if($this.LogFile){
		Add-Content -Path $this.LogFile -Value $text
		}
		$this.writelogCallBack.Invoke($text)
	
	}

	[void] startLogs(){
		$this.sourcepowershellcode.Length
		$this.writeLog("Source Size:  "+$this.sourcepowershellcode.Length)
		$this.writeLog("Planned:")
		$paln = "Source --> "
		foreach($i in $this.Items){
		$paln += $i.ToString()
		$paln += " --> "
		}
		$paln += "Result"
		$this.writeLog($paln)

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
param (
	[switch]$noGUI,
	[switch]$help,
	[switch]$SList,
	[switch]$TList,
	[String]$t,
	[String]$sourceFile,
	[String]$outFile,
	[String]$inputSource
)

### PSEncoder core
. ($PSScriptRoot+[IO.Path]::DirectorySeparatorChar+"ScriptStorage.ps1")
. ($PSScriptRoot+[IO.Path]::DirectorySeparatorChar+"LauncherStorage.ps1")
. ($PSScriptRoot+[IO.Path]::DirectorySeparatorChar+"TransformStorage.ps1")
. ($PSScriptRoot+[IO.Path]::DirectorySeparatorChar+"GUIForm.ps1")
. ($PSScriptRoot+[IO.Path]::DirectorySeparatorChar+"PSEncoderWorker.ps1")

#############------------STARTER---------------------------

Add-Type -AssemblyName PresentationFramework
Add-Type -AssemblyName presentationcore
Add-Type -AssemblyName windowsbase
Add-Type -AssemblyName System.Windows.Forms

function showAbout {
	Add-Type -AssemblyName System.Windows.Forms
	Add-Type -AssemblyName System.Drawing

	$form = New-Object System.Windows.Forms.Form
	$form.Text = 'About'
	$form.Size = New-Object System.Drawing.Size(450,200)
	$form.StartPosition = 'CenterScreen'

	$OKButton = New-Object System.Windows.Forms.Button
	$OKButton.Location = New-Object System.Drawing.Point(350,120)
	$OKButton.Size = New-Object System.Drawing.Size(75,23)
	$OKButton.Text = 'OK'
	$OKButton.DialogResult = [System.Windows.Forms.DialogResult]::OK
	$form.AcceptButton = $OKButton
	$form.Controls.Add($OKButton)

	$label = New-Object System.Windows.Forms.Label
	$label.Location = New-Object System.Drawing.Point(10,20)
	$label.Size = New-Object System.Drawing.Size(330,20)
	$label.Text = 'PShellEncoder is a utilite for generate any powershell payloads'
	$form.Controls.Add($label)

	$label2 = New-Object System.Windows.Forms.Label
	$label2.Location = New-Object System.Drawing.Point(10,40)
	$label2.Size = New-Object System.Drawing.Size(330,20)
	$label2.Text = 'Create by DxRvs'
	$form.Controls.Add($label2)

	$form.Topmost = $true

	$form.ShowDialog()
}

function Invoke-GUI {
 Param ([ScriptStorage]$sStorage ,[TransformStorage]$tStorage ,[LauncherStorage] $lStorage)
 $reader=[System.Xml.XmlNodeReader]::new([GUIForm]::inputMainFormXML)
 $MainForm=[Windows.Markup.XamlReader]::Load( $reader )

 #control elements
 [System.Windows.Controls.Button] $buttonEncode = $MainForm.FindName("buttonEncode")
 [System.Windows.Controls.Button] $buttonDecode = $MainForm.FindName("buttonDecode")
 [System.Windows.Controls.Button] $buttonCopy = $MainForm.FindName("buttonCopy")
 [System.Windows.Controls.Button] $buttonRun = $MainForm.FindName("buttonRun")
 [System.Windows.Controls.Button] $buttonAddMethod = $MainForm.FindName("buttonAddMethod")
 [System.Windows.Controls.Button] $buttonDelMethod = $MainForm.FindName("buttonDelMethod")
 [System.Windows.Controls.Button] $buttonApply = $MainForm.FindName("buttonApply")
 [System.Windows.Controls.Button] $buttonBuild = $MainForm.FindName("buttonBuild")
 [System.Windows.Controls.Button] $buttonCopyRes = $MainForm.FindName("buttonCopyRes")
 [System.Windows.Controls.Button] $buttonUse = $MainForm.FindName("buttonUse")
 [System.Windows.Controls.RichTextBox] $richTextBoxSource = $MainForm.FindName("richTextBoxSource")
 [System.Windows.Controls.RichTextBox] $richTextBoxResult = $MainForm.FindName("richTextBoxResult")
 [System.Windows.Controls.MenuItem] $MenuItemShowAbout  = $MainForm.FindName("MenuItemShowAbout")
 [System.Windows.Controls.MenuItem] $MenuItemLoadFile  = $MainForm.FindName("MenuItemLoadFile")
 [System.Windows.Controls.MenuItem] $MenuItemSetLog  = $MainForm.FindName("MenuItemSetLog")
 [System.Windows.Controls.MenuItem] $MenuItemSaveResult  = $MainForm.FindName("MenuItemSaveResult")
 [System.Windows.Controls.ListView] $listViewMethods = $MainForm.FindName("listViewMethods")
 [System.Windows.Controls.ListView] $listViewScriptCategosies = $MainForm.FindName("listViewScriptCategosies")
 [System.Windows.Controls.ListView] $listViewScripts = $MainForm.FindName("listViewScripts")
 [System.Windows.Controls.ListView] $listViewLaunchers = $MainForm.FindName("listViewLaunchers")
 [System.Windows.Controls.ListView] $listViewSelectedMethods = $MainForm.FindName("listViewSelectedMethods")
 [System.Windows.Controls.RichTextBox] $richTextBoxComments = $MainForm.FindName("RichTextBoxComments")
 [System.Windows.Controls.RichTextBox] $richTextBoxResultLog = $MainForm.FindName("richTextBoxResultLog")
 [System.Windows.Controls.RichTextBox] $richTextResultLaunch = $MainForm.FindName("RichTextResultLaunch")
 [System.Windows.Controls.RichTextBox] $RichTextBoxScriptComments = $MainForm.FindName("RichTextBoxScriptComments")
 [System.Windows.Controls.CheckBox] $CheckBoxHiden = $MainForm.FindName("checkBoxHiden")
 [System.Windows.Controls.Label] $labelLengthLaunch = $MainForm.FindName("labelLengthLaunch")
 [System.Windows.Controls.TabControl] $tabControl = $MainForm.FindName("tabControl")

 [System.Windows.Window]$Windows = $MainForm.FindName("mainW")
 $Windows.ResizeMode = [System.Windows.ResizeMode]::CanMinimize
 $Windows.Title=[GUIForm]::NAME+" "+ [GUIForm]::APP_VERSION
 $icofile =[System.Convert]::FromBase64String([GUIForm]::icon)
 [System.IO.MemoryStream] $mstream = [System.IO.MemoryStream]::new($icofile)
 [System.Windows.Media.Imaging.BitmapFrame] $bitmap =[System.Windows.Media.Imaging.BitmapFrame]::Create($mstream)
 $Windows.Icon=$bitmap

 [System.Windows.Documents.FlowDocument] $fdoc = [System.Windows.Documents.FlowDocument]::new()
 $rp = [GUIForm]::runPref
 [PSEncoderWorker] $Script:psEncoder = $null
 [String] $Script:logFile = $null
 
########	default transform set
	$defailtTransform = $tStorage.getDefaultTransformSet()
		foreach($i in $defailtTransform.getName()){
			$listViewSelectedMethods.AddChild($i)
		}
########	Launcher PANEL_CATIGORIES
	
		foreach($i in $sStorage.ListCat){
			$listViewScriptCategosies.AddChild($i)
		}
		$listViewScriptCategosies.SelectedIndex=0
		$selscript = $listViewScriptCategosies.SelectedItem
		
		$selScripts = $sStorage.getScripyByCaterory($selscript)
		foreach($i in $selScripts){
			$listViewScripts.AddChild($i.Name)
		}
		$listViewScriptCategosies.add_SelectionChanged({
			$selScripts = $sStorage.getScripyByCaterory($listViewScriptCategosies.SelectedItem)
		$listViewScripts.Items.Clear()
		foreach($i in $selScripts){
			$listViewScripts.AddChild($i.Name)
		}
	})
		$listViewScripts.add_SelectionChanged({
		$selScripts = $sStorage.getScriptbyName($listViewScripts.SelectedItem)
		$RichTextBoxScriptComments.Document.Blocks.Clear();
			$runtext =[System.Windows.Documents.Run]::new($selScripts.Description)
			$Paragraph = [System.Windows.Documents.Paragraph]::new($runtext)
			$RichTextBoxScriptComments.Document.Blocks.Add($Paragraph)
		})
	$buttonUse.add_Click({
		$selScr = $listViewScripts.SelectedItem
		if($selScr){
				$sscripts = $sStorage.getScriptbyName($selScr)
				$richTextBoxSource.Document.Blocks.Clear()
				$richTextBoxSource.AppendText($sscripts.Source)
				$tabControl.SelectedIndex=1
			}
		})
	##TODO!
	

  ########	Launcher PANEL_LAUNCHERS
	foreach($l in $lStorage.LauncherList){
	$listViewLaunchers.AddChild($l.getName())
	}
	$listViewLaunchers.SelectedIndex = 0
  ########	Trahsformation PANEL
	
	foreach($tr in $tStorage.TransformList){
	$listViewMethods.AddChild($tr.getName())
	}
	$listViewMethods.add_SelectionChanged({
		$t = $tStorage.getTransformbyName($this.SelectedItem)
		if ($t -ne $null){
			$richTextBoxComments.Document.Blocks.Clear();
			$runtext =[System.Windows.Documents.Run]::new($t.getDescription())
			$Paragraph = [System.Windows.Documents.Paragraph]::new($runtext)
			$richTextBoxComments.Document.Blocks.Add($Paragraph)

			$runtext =[System.Windows.Documents.Run]::new("Example:")
			$Paragraph = [System.Windows.Documents.Paragraph]::new($runtext)
			$richTextBoxComments.Document.Blocks.Add($Paragraph)

			$runtext =[System.Windows.Documents.Run]::new($t.getExample())
			$Paragraph = [System.Windows.Documents.Paragraph]::new($runtext)
			$richTextBoxComments.Document.Blocks.Add($Paragraph)
			}
	})
	$buttonAddMethod.add_Click({
	$selected_methods =  $listViewMethods.SelectedItem
		if ($selected_methods -ne $null){
		$listViewSelectedMethods.AddChild($selected_methods)
		}
	})
	$buttonDelMethod.add_Click({
	$selected_methods = $listViewSelectedMethods.SelectedIndex
		if ($selected_methods -gt -1){
			$listViewSelectedMethods.Items.RemoveAt($selected_methods)
		}

	})
	$buttonApply.add_Click({
	[System.Windows.Controls.ItemCollection] $i =$listViewSelectedMethods.Items
	$sourcetext = (New-Object  System.Windows.Documents.TextRange($richTextBoxSource.Document.ContentStart, $richTextBoxSource.Document.ContentEnd)).Text;
	$richTextBoxResultLog.Document.Blocks.Clear()
	[Collections.Generic.LinkedList[String]] $Items = [Collections.Generic.LinkedList[String]]::new()
		$i.ForEach({
		$Items.Add($_.ToString())
		})

	 $Script:psEncoder = [PSEncoderWorker]::new($sourcetext,$Items,$tStorage,{
	 	Param([string] $text)
		$runtext =[System.Windows.Documents.Run]::new($text)
		$Paragraph = [System.Windows.Documents.Paragraph]::new($runtext)
		$richTextBoxResultLog.Document.Blocks.Add($Paragraph)
		$richTextBoxResultLog.ScrollToEnd()
	 })
	$Script:psEncoder.LogFile=$Script:logFile
	$tabControl.SelectedIndex=3

	})
	
 ########	Result PANEL
	$buttonBuild.add_Click({
		
	if ($Script:psEncoder -ne $null){
		$result = $Script:psEncoder.run()
		$richTextBoxResult.Document.Blocks.Clear()
		$runtext =[System.Windows.Documents.Run]::new($result)
		$Paragraph = [System.Windows.Documents.Paragraph]::new($runtext)
		$richTextBoxResult.Document.Blocks.Add($Paragraph)
		
	}
	})
	$buttonCopyRes.add_Click({
	$enctext = (New-Object  System.Windows.Documents.TextRange($richTextBoxResult.Document.ContentStart, $richTextBoxResult.Document.ContentEnd)).Text;
	  if($enctext.Length -gt 2)
	  {$ch = $enctext.Substring(0,$enctext.Length-2)}
	else{
		$ch=$enctext
	}
	   Set-Clipboard -Value $ch
  })
 ########	Button___Launchers
  $buttonEncode.add_Click({
	
	$launcher_name = $listViewLaunchers.SelectedItem.ToString()
	[Launcher]$launcher  = $lStorage.getLauncherbyName($launcher_name)
	 
	if ($launcher -ne $null){
	$resultSource = (New-Object  System.Windows.Documents.TextRange($richTextBoxResult.Document.ContentStart, $richTextBoxResult.Document.ContentEnd)).Text;
	$richTextResultLaunch.Document.Blocks.Clear();
	$launchString= $launcher.getRunStr($resultSource);
	
	if ($CheckBoxHiden.IsChecked)
		{
			$launchString = "powershell -w hidden" + $launchString.Substring("powershell".Length)
		}
	
	$richTextResultLaunch.AppendText($launchString);
	$labelLengthLaunch.Content="Length: "+$launchString.Length+" / 4096 /8190 (max)"
	}
	})	
  $buttonDecode.add_Click({
	$launcher_name = $listViewLaunchers.SelectedItem.ToString()
	[Launcher]$launcher  = $lStorage.getLauncherbyName($launcher_name)
	if ($launcher -ne $null){
	$enctext = (New-Object  System.Windows.Documents.TextRange($richTextResultLaunch.Document.ContentStart, $richTextResultLaunch.Document.ContentEnd)).Text;
	$source  = $launcher.getSource($enctext)
	$richTextBoxResult.Document.Blocks.Clear();
	$richTextBoxResult.AppendText($source);
	$tabControl.SelectedIndex=3
	}
  })
  $buttonCopy.add_Click({
  $enctext = (New-Object  System.Windows.Documents.TextRange($richTextResultLaunch.Document.ContentStart, $richTextResultLaunch.Document.ContentEnd)).Text;
	  if($enctext.Length -gt 2)
	  {$ch = $enctext.Substring(0,$enctext.Length-2)}
	else{
		$ch=$enctext
	}
	   Set-Clipboard -Value $ch
  })
  $buttonRun.add_Click({
	$runCMD = (New-Object  System.Windows.Documents.TextRange($richTextResultLaunch.Document.ContentStart, $richTextResultLaunch.Document.ContentEnd)).Text;
	$runCMD="/c start  cmd /K "+$runCMD
	Start-Process cmd.exe -ArgumentList $runCMD
	})

############## MAIN MENU
  $MenuItemShowAbout.add_Click({
	$selected = showAbout	
})
  $MenuItemLoadFile.add_Click({

    $OpenFileDialog = New-Object System.Windows.Forms.OpenFileDialog
    $OpenFileDialog.ShowDialog() | Out-Null
    if ($OpenFileDialog.filename){
	$bytes = Get-Content -Path $OpenFileDialog.filename -Encoding Byte
	$mainscript = [System.Text.Encoding]::UTF8.GetString($bytes)
	$richTextBoxSource.Document.Blocks.Clear()
	  $richTextBoxSource.AppendText($mainscript)
	  $tabControl.SelectedIndex=1
		}
  })
  $MenuItemSetLog.add_Click({
  $OpenFileDialog = New-Object System.Windows.Forms.SaveFileDialog 
  $OpenFileDialog.ShowDialog() | Out-Null
	  if ($OpenFileDialog.filename){
		   $Script:logFile = $OpenFileDialog.filename
	  }
  })
  $MenuItemSaveResult.add_Click({
	  
  $OpenFileDialog = New-Object System.Windows.Forms.SaveFileDialog 
  $OpenFileDialog.ShowDialog() | Out-Null
	  if ($OpenFileDialog.filename){
		   $resulttext = (New-Object  System.Windows.Documents.TextRange($richTextBoxResult.Document.ContentStart, $richTextBoxResult.Document.ContentEnd)).Text;

	  if($resulttext.Length -gt 2)
		 {$resulttext = $resulttext.Substring(0,$resulttext.Length-2)}
		  Add-Content -Path $OpenFileDialog.filename -Value $resulttext
	  }
  })

  $MainForm.ShowDialog()

}


function Invoke-guiPSEncoder{
#START
[ScriptStorage] $sStorage = [ScriptStorage]::new()
[TransformStorage] $tStorage  =[TransformStorage]::new()
[LauncherStorage] $lStorage  =[LauncherStorage]::new()
Invoke-GUI -sStorage $sStorage -tStorage $tStorage  -lStorage $lStorage
exit
}
function GetCorrectStringEncoding($bytes){
    # Analyze the BOM
	# return Encoding.UTF7;
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

function Invoke-uiPSEncoder{
[ScriptStorage] $sStorage = [ScriptStorage]::new()
[TransformStorage] $tStorage  =[TransformStorage]::new()
[LauncherStorage] $lStorage  =[LauncherStorage]::new()

	if($SList){
		foreach($s in $sStorage.ScriptList){
			Write-Host $s.Name
		}
		exit
	}
	if($TList){
		foreach($s in $tStorage.TransformList){
		Write-Host $s.getName()
			}
		exit
		}
	if($t -ne $null){

		
			$transfs = $t.Split(",")
			[Collections.Generic.LinkedList[String]] $list = [Collections.Generic.LinkedList[String]]::new()
			Write-Host "Transforms count:" $transfs.Length
			foreach($tr in $transfs){
				$tr = $tr.trim();
				$transform = $tStorage.getTransformbyName($tr)
				if($transform -eq $null){
				Write-Host "Unknown transform: " $tr
				exit
				}
				$list.Add($transform.getName())
			}
		$sourceScript=""
		if ($inputSource.Length -gt 0) {$sourceScript = $inputSource
		Write-Host "inputSource = " $inputSource
		}
		else{
			if ($sourceFile.Length -gt 0){
		if(Test-Path $sourceFile){

			$sourceScript = GetCorrectStringEncoding( [System.IO.File]::ReadAllBytes($sourceFile))
			
		}else{
		Write-Host "Unknown path:" $s
		}
			}
			}
		[PSEncoderWorker] $PSEncoderWorker = [PSEncoderWorker]::new($sourceScript,$list,$tStorage,{
				Param([string] $text)
				Write-Host $text
			})
			$resulr=  $PSEncoderWorker.run()
			if ($outFile.Length -gt 0 ){
				Out-File -FilePath $outFile -InputObject $resulr -Encoding utf8 -NoNewline 
				Write-Host "out file: "$outFile
			}else{
				Write-Host $resulr
			}
	}
}

if($help){
	Write-Host "Use arguments:"
	Write-Host "-SList print list of scripts"
	Write-Host "-TList print list of transforms"
	Write-Host "-t transforms list [tr1,tr2]"
	Write-Host "-sourceFile source script path"
	Write-Host "-inputSource source script string"
	Write-Host "-noGUI disable GUI"
	Write-Host "-help print this message"
}else
{
	if(!$noGUI){
		Invoke-guiPSEncoder
	}else{
		Invoke-uiPSEncoder
	}
}

Info:
=============
**PShellEncoder** is a utility for generate any powershell payloads. May use with GUI.

Used some code from:

<pre>
https://github.com/danielbohannon/Invoke-Obfuscation.git
https://github.com/PowerShellMafia/PowerSploit.git
</pre>


Build:
=============
<pre>
powershell ./Build.ps1
</pre>
or with docker
<pre>
sudo docker run -it -v "$PWD":/root mcr.microsoft.com/powershell pwsh -c  'cd /root/ ; ./Build.ps1'
</pre>
<pre>
build result in "./build/" directory
</pre>
Run:
=============
<pre>
powershell ./PShellEncoder.ps1
or
powershell ./PSEncoderUI.ps1
</pre>
Note:
=============

Detected by Windows Defender

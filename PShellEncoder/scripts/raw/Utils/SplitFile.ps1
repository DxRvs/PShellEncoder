<#
<description>Split file
<description>
#>
<#
<categories>
utils
<categories>
#>
$from = "C:\temp\test.jpg"
$rootName = "C:\temp\split"
$ext = "bin"
$upperBound = 100KB #2MB
$fromFile = [io.file]::OpenRead($from)
$buff = new-object byte[] $upperBound
$count = $idx = 0
try {
    do {
        $count = $fromFile.Read($buff, 0, $buff.Length)
        if ($count -gt 0) {
            $to = "{0}.{1}.{2}" -f ($rootName, $idx, $ext)
            $toFile = [io.file]::OpenWrite($to)
            try {
                $tofile.Write($buff, 0, $count)
            } finally {
                $tofile.Close()
            }
        }
        $idx ++
    } while ($count -gt 0)
}
finally {
    $fromFile.Close()
}


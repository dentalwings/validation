Param([string]$Branch = "master")


$testsZip = "$Env:TMP\dwdiag.zip"
$testsDir = "$Env:TMP\dwdiag"

if (Test-Path $testsDir) { Remove-Item –Path $testsDir -Recurse -Force }
(New-Object Net.WebClient).DownloadFile("https://github.com/dentalwings/validation/archive/$Branch.zip", $testsZip)
Expand-Archive -Path $testsZip -DestinationPath $testsDir

& $testsDir\validation-$Branch\run.ps1

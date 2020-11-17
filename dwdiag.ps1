Param([string]$Branch)

$testsZip = "$Env:TMP\dwdiag.zip"
$testsDir = "$Env:TMP\dwdiag"

if (Test-Path $testsDir) { Remove-Item –Path $testsDir -Recurse -Force }
(New-Object Net.WebClient).DownloadFile("https://github.com/dentalwings/validation/archive/$Branch.zip", $testsZip)
$zip = [System.IO.Compression.ZipFile]::Open($testsZip, 'read')
[IO.Compression.ZipFileExtensions]::ExtractToDirectory($zip,$testsDir)

& $testsDir\run.ps1

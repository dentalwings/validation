Param([bool]$Manual = $false)

function Get-Tags
{ Param([string]$Systen, [string[]]$Variant)
	return @($Systen, $Variant, "$Systen-$Variant")
}
function Get-TagsFromScannerInfo
{ Param([string]$File)

    $info = Get-Content $File | Select-Object -Skip 3 | ConvertFrom-StringData
    switch ($info.variant) {
        "Dental Wings" { 
			$tags = Get-Tags $info.model "dwos"
         }
         "Straumann" { 
			$tags = Get-Tags $info.model "cares"
          }
        Default {}
    }
    return $tags
}

function Select-Tag()
{ Param([string]$Name, [string[]]$Tags)

    $choices = $Tags | % {"&$_"}
    $prompt = $host.ui.PromptForChoice("", "Select your $Name", $choices, 0)
    return $Tags[$prompt]
}

$scannerinfoPath = "C:\DWOS\scannerinfo.ini"
if((!$Manual) -and (Test-Path $scannerinfoPath)) {
    $tags = Get-TagsFromScannerInfo $scannerinfoPath
}
if($tags -eq $null) {
    $system = Select-Tag "System" @("7Series", "3Series", "medit", "chairside")
    $variant = Select-Tag "Variant" @("dwos", "cares")
    $tags = Get-Tags $system $variant
}
Write-Host "Will run the tests with tags: $tags"
Invoke-Pester -Tags $tags -Script @{Path = "$PSScriptRoot\Tests"; Parameters = @{Tags = $tags}}

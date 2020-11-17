Param([bool]$Manual = $false)

function Get-TagsFromScannerInfo
{
    $info = Get-Content 'C:\DWOS\scannerinfo.ini' | Select-Object -Skip 3 | ConvertFrom-StringData
    switch ($info.variant) {
        "Dental Wings" { 
            $scanner = $info.model
            $variant = "dwos"
            $scannerVariant = "$scanner-$variant"
         }
         "Straumann" { 
             $scanner = $info.model
             $variant = "cares"
             $scannerVariant = "$scanner-$variant"
          }
        Default {}
    }
    return @($scanner, $variant, $scannerVariant)
}

function Select-Tag()
{ Param([string]$Name, [string[]]$Tags)

    $choices = $Tags | % {"&$_"}
    $prompt = $host.ui.PromptForChoice("", "Select your $Name", $choices, 0)
    return $Tags[$prompt]
}

if($Manual) {
    $system = Select-Tag "System" @("7Series", "3Series", "medit", "chairside")
    $variant = Select-Tag "Variant" @("dwos", "cares")
    $tags = @($system, $variant, "$system-$variant")
} else {
    $tags = Get-TagsFromScannerInfo 
}
Invoke-Pester -Tags $tags -Script @{Path = "$PSScriptRoot\Tests"; Parameters = @{Tags = $tags}}

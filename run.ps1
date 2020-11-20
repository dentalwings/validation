Param([bool]$Manual = $false)

function Get-TagsFromConfigFiles {
    Param([string]$File)

    $info = Get-Content $File | Select-Object -Skip 3 | ConvertFrom-StringData
    Switch ($info.variant) {
        "Dental Wings" { 
            $tags = @($info.model, "dwos")
        }
        "Straumann" { 
            $tags = @($info.model, "cares")
        }
        Default {}
    }

    If (Test-Path 'C:/ProgramData/coDiagnostiX/DWSynergySrv'){
        $tags += "Synergy"
    }
    $tags
}

function Select-Tag() {
    Param([string]$Name, [string[]]$Tags)

    $choices = $Tags | ForEach-Object { "&$_" }
    $prompt = $host.ui.PromptForChoice("", "Select your $Name", $choices, 0)
    return $Tags[$prompt]
}

$scannerinfoPath = "C:\DWOS\scannerinfo.ini"
if ((!$Manual) -and (Test-Path $scannerinfoPath)) {
    $tags = Get-TagsFromConfigFiles $scannerinfoPath
}
if ($null -eq $tags) {
    $system = Select-Tag "System" @("7Series", "3Series", "medit", "chairside")
    $variant = Select-Tag "Variant" @("dwos", "cares")
    $tags = @($system, $variant)
    $synergy = Select-Tag "Optional Software" @("None", "Synergy")
    If ($synergy -ne "None") {
        $tags += $synergy
    }
}
Write-Host "Will run the tests with tags: $tags"
Invoke-Pester -Tags $tags -Script @{Path = "$PSScriptRoot\Tests"; Parameters = @{Tags = $tags } }

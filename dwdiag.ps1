Param([string]$Branch)


function DownloadFilesFromRepo {
Param([string]$Path,
[string]$Branch)

    $baseUri = "https://api.github.com/repos/dentalwings/validation/contents/Tests"
    If ( $Branch ) {
        $baseUri += "?ref=$Branch"
    }
    try {
        $objects = $(Invoke-WebRequest -UseBasicParsing -Uri $($baseuri)) | ConvertFrom-Json
    }
    catch {
        If ( $Branch ) {
           Write-Error "No diagnostics found in branch $Branch"
        }
        Else {
           Write-Error "No diagnostics found for master"
           $_
        }
    }

    If (-Not (Test-Path -Path "$Env:TMP\dwdiag" )) {
        New-Item -Path "$Env:TMP" -Name "dwdiag" -ItemType "directory" | Out-Null
    }
    $objects | where {$_.type -eq "file" -and $_.name.Split(".")[-1] -eq "ps1"} | ForEach-Object {
        $target_file = "$Env:TMP\dwdiag\$($_.name)"
        try {
            Invoke-WebRequest -UseBasicParsing -Uri $_.download_url -OutFile $target_file -ErrorAction Stop
        }
        catch {
            throw "Unable to download '$($_.path)'"
        }
    }
}

function Get-Tags($info){
    $info = Get-Content 'C:\DWOS\scannerinfo.ini' | Select-Object -Skip 3 | ConvertFrom-StringData
    switch ($info.variant) {
        "Dental Wings" { 
            $scanner = $info.model
            $variant = "dwos"
            $scannerVariant = "${info.model}-dwos"
         }
         "Straumann" { 
             $scanner = $info.model
             $variant = "cares"
             $scannerVariant = "${info.model}-dwos"
          }
        Default {}
    }
    return @($scanner, $variant, $scannerVariant)
}


DownloadFilesFromRepo -Branch $Branch
$tags = Get-Tags 
Invoke-Pester -Tags $tags -Script @{Path = "$Env:TMP\dwdiag"; Parameters = @{Tags = $tags}}
Remove-Item –Path $Env:TMP\dwdiag -Recurse -Force

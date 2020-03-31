﻿Param([string]$Branch)


function DownloadFilesFromRepo {
Param([string]$Path,
[string]$Branch)

    $baseUri = "https://api.github.com/repos/dentalwings/validation/contents/$Path"
    If ( $Branch ) {
        $baseUri += "?ref=$Branch"
    }
    try {
        $objects = $(Invoke-WebRequest -Uri $($baseuri)) | ConvertFrom-Json
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
    
    $directories = $objects | where {$_.type -eq "dir"}
    If ($directories) {
        "Which diagnostics should we run ?"
        $directories | % {$i=1} {"$i) $($_.name)"; $i++}

        do
        {
            try {
                [ValidatePattern('^\d+$')]$Index = Read-Host "Enter the number" 
                If ($Index -Gt $directories.Length -or $Index -eq 0) {
                    "Wrong choice"
                    throw
                }
            } catch {}
        } until ($?)
        DownloadFilesFromRepo -Path $($directories[$Index-1].name) -Branch $Branch
    }
    Else {
        $objects | where {$_.type -eq "file" -and $_.name.Split(".")[-1] -eq "ps1"} | ForEach-Object {
            $target_file = "$Env:TMP/$($_.name)"
            try {
                Invoke-WebRequest -Uri $_.download_url -OutFile $target_file -ErrorAction Stop
            }
            catch {
                throw "Unable to download '$($_.path)'"
            }
            Invoke-Pester $target_file
            Remove-Item –Path $target_file
        }
    }
}

DownloadFilesFromRepo -Branch $Branch

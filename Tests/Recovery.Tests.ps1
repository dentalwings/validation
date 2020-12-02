Describe "Recovery tests" -Tags "7Series", "3Series", "Medit" {

  $versions = (wbadmin get versions | select-String -Pattern "Version identifier: ")
  $versionid = $versions -replace "Version identifier: "
  $Dvolume = (wbadmin get items -version:$versionid | select-String -Pattern "mounted at D:")

  It "Contain one recovery image" {
    $versions.Count | should be 1
  }

  It "Does not incude D in the recovery" {
    $Dvolume.Count | should be 0
  }
  
  It "BackupPartitionFixed RegKey is not set if D is included in recovery" {
    $BackupPartitionFixed = Get-ItemProperty -Path "HKLM:\SOFTWARE\WOW6432Node\DWOS" -Name "BackupPartitionFixed" -ErrorAction SilentlyContinue
    $BackupPartitionFixed -and ($Dvolume.Count -gt 0) | should be $False
  }
}

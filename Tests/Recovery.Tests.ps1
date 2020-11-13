Describe "Recovery tests" -Tags "7Series","3Series","Medit" {

  $versions = (wbadmin get versions | select-String -Pattern "Version identifier: ")

  It "Contain one recovery image" {
    $versions.Count | should be 1
  }

  It "Does not incude D in the recovery" {
    $versionid = $versions -replace "Version identifier: "
    wbadmin get items -version:$versionid
    $Dvolume = (wbadmin get versions | select-String -Pattern "mounted at D:")
    $Dvolume.Count | should be 0
  }
}

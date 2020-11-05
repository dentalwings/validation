Describe "Recovery tests" -Tags "LabScanner" {

  $versions = (wbadmin get versions | select-String -Pattern "Version identifier: ")

  it "Contain one recovery image" {
    $versions.Count | should be 1
  }

  it "Does not incude D in the recovery" {
    $versionid = $versions -replace "Version identifier: "
    wbadmin get items -version:$versionid
    $Dvolume = (wbadmin get versions | select-String -Pattern "mounted at D:")
    $Dvolume.Count | should be 0
  }
}

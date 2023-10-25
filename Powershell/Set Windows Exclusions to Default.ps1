# set exclusions to default https://support.huntress.io/hc/en-us/articles/4410656796691-How-do-I-remove-Managed-AV-host-exclusions
$pathExclusions = Get-MpPreference | select ExclusionPath 
foreach ($exclusion in $pathExclusions) {
    if ($exclusion.ExclusionPath -ne $null) {
        Remove-MpPreference -ExclusionPath $exclusion.ExclusionPath
    }
}
$extensionExclusion = Get-MpPreference | select ExclusionExtension 
foreach ($exclusion in $extensionExclusion) {
    if ($exclusion.ExclusionExtension -ne $null) {
        Remove-MpPreference -ExclusionExtension $exclusion.ExclusionExtension
    }
}
$processExclusions = Get-MpPreference | select ExclusionProcess
foreach ($exclusion in $processExclusions) {
    if ($exclusion.ExclusionProcess -ne $null) {
        Remove-MpPreference -ExclusionProcess $exclusion.ExclusionProcess
    }
}
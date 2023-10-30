# Get all BitLocker volumes
$bitLockerVolumes = Get-BitLockerVolume

foreach ($volume in $bitLockerVolumes) {
    if ($volume.ProtectionStatus -eq "On") {
        Write-Output "BitLocker is enabled on drive $($volume.MountPoint)."
        
        # Retrieve the recovery key for the BitLocker volume
        $recoveryKey = $volume.KeyProtector | Where-Object { $_.KeyProtectorType -eq 'RecoveryPassword' }
        Write-Output "Recovery Key for drive $($volume.MountPoint): $($recoveryKey.RecoveryPassword)"
    } else {
        Write-Output "BitLocker is not enabled on drive $($volume.MountPoint)."
    }
}

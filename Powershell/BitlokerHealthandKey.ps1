
$PrimDriveOn="No Drives have Bitlocker On"
$PrimDriveOff="No Drives have Bitlocker Off"
$PrimDriveStatusCode=1 #1 = OK, 2 = Fail, 3 = warning (BitLockerNotSupported)
$BitlockerStatus=2 #1 = OK, 2 = Fail, 3 = warning (BitLockerNotSupported)


if (Get-Command "get-bitlockervolume" -ErrorAction SilentlyContinue )
{

    #IF ENABLED, SET BITLOCKERFEATURESTATUS TO OK
    $BitLockerFeature="Turned On"
    $BitlockerStatus=1

    #GET BITLOCKER STATUS
    $Bitlocklist = Get-BitLockerVolume $(Get-WmiObject -Class Win32_LogicalDisk | Where-Object { $_.DriveType -eq 3 }).DeviceID -errorAction SilentlyContinue

    #GO THROUGH DRIVES
    foreach($bitlockinfo in $Bitlocklist)
    {
        if($bitlockinfo.VolumeStatus -ne "FullyEncrypted")
        {
            $PrimDriveStatusCode=2
            if($PrimDriveOff -eq "No Drives have Bitlocker Off")
            {
                $PrimDriveOff=$bitlockinfo.MountPoint + " is " + $bitlockinfo.VolumeStatus

            }
            else
            {
                $PrimDriveOff=$PrimDriveOff +", " + $bitlockinfo.MountPoint + " is " + $bitlockinfo.VolumeStatus

            }
        }
        else
        {
            if($PrimDriveOn -eq "No Drives have Bitlocker On")
            {
                $PrimDriveOn=$bitlockinfo.MountPoint + " is " + $bitlockinfo.VolumeStatus

            }
            else
            {
                $PrimDriveOn=$PrimDriveOn +", " + $bitlockinfo.MountPoint + " is " + $bitlockinfo.VolumeStatus

            }
        }
    }
}
else
{
    #"BITLOCKER NOT TURNED ON"
    $WinVer = (Get-WmiObject -class Win32_OperatingSystem).Caption
    if($WinVer -like "*home*")
    {
        $BitlockerStatus=2
        $BitLockerFeature = $WinVer + " does not support Bitlocker"

        $OtherDriveOn="Bitlocker not enabled, no information returned"
        $OtherDriveOff="Bitlocker not enabled, no information returned"
        $OtherDriveStatusCode=2 #1 = OK, 2 = Fail, 3 = warning (BitLockerNotSupported)

        $PrimDriveOn="Bitlocker not enabled, no information returned"
        $PrimDriveOff="Bitlocker not enabled, no information returned"
        $PrimDriveStatusCode=2 #1 = OK, 2 = Fail, 3 = warning (BitLockerNotSupported)    
    }
    else
    {
        $BitlockerStatus=3
        $BitLockerFeature = $WinVer + "Supports BitLocker but the feature is not installed"

        $OtherDriveOn="Bitlocker not enabled, no information returned"
        $OtherDriveOff="Bitlocker not enabled, no information returned"
        $OtherDriveStatusCode=3 

        $PrimDriveOn="Bitlocker not enabled, no information returned"
        $PrimDriveOff="Bitlocker not enabled, no information returned"
        $PrimDriveStatusCode=3 
    }
}

"BitlockerFeatureStatusCode : " + $BitlockerStatus
"BitlockerFeatureDetails : " + $BitLockerFeature

"Drive With BitLocker On : " + $PrimDriveOn
"Drive With BitLocker Off: " + $PrimDriveOff
"Drive Status Code : " + $PrimDriveStatusCode


# Detect OneDrive Client Version >19.192.926.12 on Device
# This is used for ConfigMgr Application Detection

# Set ErrorActionPreference
$ErrorActionPreference = "SilentlyContinue"

# Determine current logged on user
$UserName = Get-WmiObject -Class Win32_ComputerSystem | Select-Object -ExpandProperty UserName

# Create a hash-table for each UserProfileList with translated SIDs
$ProfileTable = @{}
$UserProfileListItems = Get-ItemProperty -Path "Registry::HKEY_LOCAL_MACHINE\Software\Microsoft\Windows NT\CurrentVersion\ProfileList\*"
ForEach ($UserProfileListItem in $UserProfileListItems) {
    $SecurityIdentifier = New-Object -TypeName System.Security.Principal.SecurityIdentifier($UserProfileListItem.PSChildName)
    $UserNameTranslated = $SecurityIdentifier.Translate([System.Security.Principal.NTAccount])
    If ($UserNameTranslated -ne $null) {
        $ProfileTable.Add($UserNameTranslated.Value, $UserProfileListItem.ProfileImagePath)
    }
}

# Determine user profile path from current logged on user
$UserProfilePath = $ProfileTable[$UserName]

# Construct OneDrive.exe path
$OneDrivePath = Join-Path -Path $UserProfilePath -ChildPath "\AppData\Local\Microsoft\OneDrive\OneDrive.exe"

# Validate OneDrive.exe file exists and check version
If (Test-Path -LiteralPath $OneDrivePath) {
    # Load required assembly to perform version check
    [System.Reflection.Assembly]::LoadWithPartialName("System.Version")

    # Set minimum required version - make sure you include leading zeros or detection may fail! (19.192.926.12 vs. 19.192.0926.0012)
    $OneDriveRequiredVersion = New-Object -TypeName System.Version -ArgumentList "19.192.0926.0012"

    # Get existing OneDrive.exe version
    $CurrentOneDriveVersion = New-Object -TypeName System.Version -ArgumentList ((Get-Item -LiteralPath $OneDrivePath).VersionInfo | Select-Object -ExpandProperty FileVersion)

    # Return output to STDOUT if current OneDrive.exe version is higher than the minimum required version
    switch ($CurrentOneDriveVersion.CompareTo($OneDriveRequiredVersion)) {
        0 { return $true }
        1 { return $true }
    }
}

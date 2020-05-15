# Find all User Profiles in the Registry
$PatternSID = 'S-1-5-21-\d+-\d+\-\d+\-\d+$'

# Get Username, SID, and location of ntuser.dat for all users
$ProfileList = @()
$ProfileList = Get-ItemProperty 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\ProfileList\*' | Where-Object { $_.PSChildName -match $PatternSID } |
Select-Object  @{ name = "SID"; expression = { $_.PSChildName } },
@{ name = "UserHive"; expression = { "$($_.ProfileImagePath)\ntuser.dat" } },
@{ name = "Username"; expression = { $_.ProfileImagePath -replace '^(.*[\\\/])', '' } 
}

# Get all user SIDs found in HKEY_USERS (ntuser.dat files that are loaded)
$LoadedHives = Get-ChildItem Registry::HKEY_USERS | Where-Object { $_.PSChildname -match $PatternSID } | Select-Object @{ name = "SID"; expression = { $_.PSChildName } }

# Backwards Compatibility (v2)
$SIDObject = @()
ForEach ($item in $LoadedHives) {
  $props = @{
    SID = $item.SID
  }
  $TempSIDObject = New-Object -TypeName PSCustomObject -Property $props
  $SIDObject += $TempSIDObject
}

# We need to use ($ProfileList | Measure-Object).count instead of just ($ProfileList).count
# because in PS V2, if the count is less than 2, it doesn't work. :)
For ($p = 0; $p -lt ($ProfileList | Measure-Object).count; $p++) {
  For ($l = 0; $l -lt ($SIDObject | Measure-Object).count; $l++) {
    If (($ProfileList[$p].SID) -ne ($SIDObject[$l].SID)) {
      $UnloadedHives += $ProfileList[$p].SID
      Write-Verbose -Message "Loading Registry hives for $($ProfileList[$p].SID)"
      REG LOAD "HKU\$($ProfileList[$p].SID)" "$($ProfileList[$p].UserHive)"

      Write-Verbose -Message 'Attempting to remove registry keys for each profile'
      #####################################################################
      # REGISTRY MODIFICATIONS ############################################
      #####################################################################

# PUT MODIFICATIONS HERE

      #####################################################################
      # REGISTRY MODIFICATIONS ############################################
      #####################################################################
      };
    }
  }
}

# Post-Script-Run Cleanup
Write-Verbose 'Unloading registry hives for all users...'
# Unload ntuser.dat
# Garbage collection and closing of ntuser.dat ###
[gc]::Collect()
REG UNLOAD "HKU\$($ProfileList[$p].SID)"

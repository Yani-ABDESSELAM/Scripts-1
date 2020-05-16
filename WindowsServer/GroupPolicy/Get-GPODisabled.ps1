#This will check if there is any settings disabled and return the GPO’s
Function Get-GPODisabled {
  [cmdletbinding()]
  param ()
  Try {
    Write-Verbose -Message "Importing GroupPolicy module"
    Import-Module GroupPolicy -ErrorAction Stop
  }
  Catch {
    Write-Error -Message "GroupPolicy Module not found. Make sure RSAT (Remote Server Admin Tools) is installed"
    Exit
  }
  $DisabledGPO = New-Object System.Collections.ArrayList
  Try {
    Write-Verbose -Message "Importing GroupPolicy Policies"  
    $GPOs = Get-GPO -All  
    Write-Verbose -Message "Found '$($GPOs.Count)' policies to check"
  }
  Catch {
    Write-Error -Message "Can't Load GPO's Please make sure you have connection to the Domain Controllers"
    Exit
  }
  ForEach ($gpo  in $GPOs) { 
    Write-Verbose -Message "Checking '$($gpo.DisplayName)' status"
    Switch ($gpo.GpoStatus) {
      "ComputerSettingsDisabled" { $DisabledGPO += "in '$($gpo.DisplayName)' the Computer Settings Disabled" }
      "UserSettingsDisabled" { $DisabledGPO += "in '$($gpo.DisplayName)' the User Settings Disabled" }
      "AllSettingsDisabled" { $DisabledGPO += "in '$($gpo.DisplayName)' All Settings Disabled" }
    }
  }
  If (($DisabledGPO).Count -ne 0) {
    Write-Host "The Following GPO's have settings disabled:"
    Return $DisabledGPO
  }
  Else {
    Return "No GPO's with setting disabled Found"
  }
}

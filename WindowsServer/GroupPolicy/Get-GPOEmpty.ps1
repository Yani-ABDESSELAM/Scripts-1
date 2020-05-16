#This function will check if there is GPO with the User or Computers settings empty. one common mistake people do, is they check the “User version” and “Computer version”, while it true that a new GPO start with version 0 on both of them and changed in each modification. but if you take an old GPO and remove all settings, the version won’t reset to 0, and you will miss those GPO’s!

Function Get-GPOEmpty {
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
  $EmptyGPO = New-Object System.Collections.ArrayList
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
    [xml]$GPOXMLReport = $gpo | Get-GPOReport -ReportType xml
    If ($null -eq $GPOXMLReport.gpo.User.ExtensionData -and $null -eq $GPOXMLReport.gpo.Computer.ExtensionData) {
      $EmptyGPO += $gpo
    }
  }
  If (($EmptyGPO).Count -ne 0) {
    Write-Host "The Following GPO's are empty:"
    Return $EmptyGPO.DisplayName
  }
  Else {
    Return "No Empty GPO's Found"
  }
}

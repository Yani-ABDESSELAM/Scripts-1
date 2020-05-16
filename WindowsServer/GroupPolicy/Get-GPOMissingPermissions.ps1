# Test for GPO’s with missing Read permissions to the “Authenticated Users” or “Domain Computers” groups.

Function Get-GPOMissingPermissions {
  [cmdletbinding()]
  Param ()
  Try {
    Write-Verbose -Message "Importing GroupPolicy module"
    Import-Module GroupPolicy -ErrorAction Stop
  }
  Catch {
    Write-Error -Message "GroupPolicy Module not found. Make sure RSAT (Remote Server Admin Tools) is installed"
    Exit
  }
  $MissingPermissionsGPOArray = New-Object System.Collections.ArrayList
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
    If ($GPO.User.Enabled) {
      $GPOPermissionForAuthUsers = Get-GPPermission -Guid $GPO.Id -All | Select-Object -ExpandProperty Trustee | Where-Object { $_.Name -eq "Authenticated Users" }
      $GPOPermissionForDomainComputers = Get-GPPermission -Guid $GPO.Id -All | Select-Object -ExpandProperty Trustee | Where-Object { $_.Name -eq "Domain Computers" }
      If (!$GPOPermissionForAuthUsers -and !$GPOPermissionForDomainComputers) {
        $MissingPermissionsGPOArray += $gpo
      }
    }
  }
  If (($MissingPermissionsGPOArray).Count -ne 0) {
    Write-Host "The following GPO's do not grant any permissions to the 'Authenticated Users' Or 'Domain Computers' Group"
    Return $MissingPermissionsGPOArray.DisplayName
  }
  Else {
    Return [string]"No GPO's with missing permissions to the 'Authenticated Users' or 'Domain Computers' groups found "
  }
}

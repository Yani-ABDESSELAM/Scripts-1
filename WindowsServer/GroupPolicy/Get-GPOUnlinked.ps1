# Unlinked GPO’s are not an “issue” but most of the time, they are useless overhead to manage and track. 

function Get-GPOUnlinked {
  [cmdletbinding()]
  param ()
  try {
      Write-Verbose -Message "Importing GroupPolicy module"
      Import-Module GroupPolicy -ErrorAction Stop
  }
  catch {
      Write-Error -Message "GroupPolicy Module not found. Make sure RSAT (Remote Server Admin Tools) is installed"
      exit
  }
  $UnlinkedGPO = New-Object System.Collections.ArrayList
  try {
      Write-Verbose -Message "Importing GroupPolicy Policies"  
      $GPOs = Get-GPO -All  
      Write-Verbose -Message "Found '$($GPOs.Count)' policies to check"
  }
  catch {
      Write-Error -Message "Can't Load GPO's Please make sure you have connection to the Domain Controllers"
      exit
  }
  ForEach ($gpo  in $GPOs) { 
      Write-Verbose -Message "Checking '$($gpo.DisplayName)' link"
      [xml]$GPOXMLReport = $gpo | Get-GPOReport -ReportType xml
      if ($null -eq $GPOXMLReport.GPO.LinksTo) { 
          $UnlinkedGPO += $gpo
      }
  }
  if (($UnlinkedGPO).Count -ne 0) {
      return $UnlinkedGPO.DisplayName
  }
  else {
      return Write-Host "No Unlinked GPO found"
  }
}

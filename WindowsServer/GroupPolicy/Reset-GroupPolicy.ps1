<#
  .Synopsis

  Clean up machines with bad (old/corrupt) machine Registry.pol files

  .DESCRIPTION

    Taking a array as input, this cmdlet assists in keeping machines in a healthy state to accept Group Policy driven changes
    by confirming the last modified date of the machines Registry.pol and if older than a day , remove it, (or doesn't exist)
    followed by a forced Machine Policy update.

    To work against older WMF/Powershell environments, invoke-command + invoke-gpupdate have been avoided.

  .EXAMPLE

    Repair-RegistryPol -Computers workstation1,workstation2

  .EXAMPLE

    Repair-RegistryPol -Computers (Import-Csv lotsofworkstations.csv)
#>

[CmdletBinding()]
Param (
  [Parameter(Mandatory = $True, Position = 0)]
  $Computers
)
foreach ($computer in $Computers) {
  if (Test-NetConnection -ComputerName $computer -Hops 1 -InformationLevel Quiet -ErrorAction SilentlyContinue -WarningAction SilentlyContinue) {
    if (Test-Path -Path \\$computer\c$\Windows\System32\GroupPolicy\Machine\Registry.pol -ErrorAction SilentlyContinue -WarningAction SilentlyContinue) {
      $regpol = Get-ChildItem \\$computer\c$\Windows\System32\GroupPolicy\Machine\Registry.pol
      if ($regpol.LastWriteTime -lt (Get-Date).AddDays(-1)) {
        Write-Host "$computer Registry.pol file is old ("$regpol.LastWriteTime"), deleting and forcing a GPUpdate" -ForegroundColor Magenta
        Remove-Item $regpol
        Invoke-WmiMethod -Name create -Path win32_process -ArgumentList "gpupdate /target:Computer /force /wait:0" -AsJob -ComputerName $computer | Out-Null
      }
      else {
        Write-Host "$computer Registry.pol file is healthy ("$regpol.LastWriteTime")" -ForegroundColor Green
      }        
    }
    elseif (Test-Path -Path \\$computer\c$\Windows\System32\GroupPolicy\Machine\ -ErrorAction SilentlyContinue -WarningAction SilentlyContinue) {
      Write-Host "$computer doesn't have a Registry.pol file, forcing a GPUpdate" -ForegroundColor Magenta
      Invoke-WmiMethod -Name create -Path win32_process -ArgumentList "gpupdate /target:Computer /force /wait:0" -AsJob -ComputerName $computer | Out-Null
    }
                    
    else {
      Write-Warning "$computer does not have c:\Windows\System32\GroupPolicy\Machine\ or you don't have access"
    }
  }  
  else {
    Write-Warning "Unable to find or contact $computer"
  }
}
<#
  .SYNOPSIS
  Edit local hosts file in C:\Windows\System32\drivers\etc\hosts

  .DESCRIPTION
  Powershell script used to add or remove entries in the local HOSTS file in Windows

  .EXAMPLE
  .\Set-HostsFile.ps1 -AddHost -IP 192.168.1.1 -Hostname dc01.contoso.com
  .\Set-HostsFile.ps1 -RemoveHost -Hostname dc01.contoso.com

  .NOTES
  Filename: Edit-HostsFile.ps1
  Version: 1.0
  Author: Martin Bengtsson
  Twitter: @mwbengtsson

  .NOTES
  Filename:   Set-HostsFile.ps1
  Version:    1.1
  Author:     Cameron Kollwitz <cameron@kollwitz.us>
  
  .NOTES
  Changelog:  1.1 - 03/19/2020: Updated Cmdlet Verb to "Set" instead of "Edit"
                                Formatting cleaup
              1.X - XX/XX/XXXX: XXX
                                XXX
                                XXX
#>

param(
  [Parameter(Mandatory = $false)]
  [string]$IP,

  [Parameter(Mandatory = $false)]
  [string]$Hostname,

  [parameter(Mandatory = $false)]
  [ValidateNotNullOrEmpty()]
  [switch]$AddHost,

  [parameter(Mandatory = $false)]
  [ValidateNotNullOrEmpty()]
  [switch]$RemoveHost
)

# Path to local hosts file
$File = "$env:windir\System32\drivers\etc\hosts"

# function to add new host to hosts file
function Add-Host([string]$fIP, [string]$fHostname) {
  Write-Verbose -Verbose -Message "Running Add-Host function..."
  $Content = Get-Content -Path $File | Select-String -Pattern ([regex]::Escape("$fHostname"))
  if (-NOT($Content)) {
    Write-Verbose -Verbose -Message "Adding $IP $Hostname to hosts file"
    $fIP + "`t" + $fHostname | Out-File -Encoding ASCII -Append $File
  }
  else {
    Write-Verbose -Verbose -Message "$Hostname already exists in the HOSTS file"
  }
}

# function to remove host from hosts file
function Remove-Host([string]$fHostname) {
  Write-Verbose -Verbose -Message "Running Remove-Host function..."
  # Get content of current hosts file
  $Content = Get-Content -Path $File
  # Create empty array for existing content
  $newLines = @()

  # Loop through each line in hosts file and determine if something needs to be kept
  foreach ($Line in $Content) {
    $Bits = [regex]::Split($Line, "\t+")
    if ($Bits.count -eq 2) {
      if ($Bits[1] -ne $fHostname) {
        # Add existing content of hosts file back to array
        $newLines += $Line
      }
    } 
    else {
      $newLines += $Line
    }
  }
  # Clearing the content of the hosts file
  Write-Verbose -Verbose -Message "Clearing content of HOSTS file"
  try {
    Clear-Content $File
  }
  catch {
    Write-Verbose -Verbose -Message "Failed to clear the content of the HOSTS file"
  }

  # Add back entries which is not being removed
  foreach ($Line in $newLines) {
    Write-Verbose -Verbose -Message "Adding back each entry which is not being removed: $Line"
    $Line | Out-File -Encoding ASCII -Append $File
  }
}

# Run the functions depending on choice when running the script
# Add host to file
if ($PSBoundParameters["AddHost"]) {

  Add-Host $IP $Hostname

}
# Remove host from file
if ($PSBoundParameters["RemoveHost"]) {

  Remove-Host $Hostname

}

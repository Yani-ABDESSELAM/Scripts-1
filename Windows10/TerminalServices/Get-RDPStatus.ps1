<#
.Synopsis
   Perform the Remote Desktop Connectivity Checks.
.DESCRIPTION
   This script will do the remote desktop connectivity checks for a given remote computer and show their status.
.EXAMPLE
   .\Get-RDPStatus.ps1 -RemoteComputer win7
#>

[cmdletBinding()]
param(
  [string]$RemoteComputer = $env:COMPUTERNAME
)

#RDP Service arrary
$RDPServices = @("TermService", "UmRdpService")

$ParamHash = [ordered]@{
  Ping        = "Failed"
  FQDN        = "Failed"
  RDPPort     = "Failed"
  RDPServices = "Failed"
  RDPSettings = "Disabled"
  RDPwithNLA  = "Enabled"
}

try {

  #Check FQDN
  if ($DNS = ([System.Net.Dns]::GetHostEntry($RemoteComputer)).HostName) { $ParamHash["FQDN"] = "Ok" ; $RemoteComputer = $DNS }
            

  if (Test-Connection -ComputerName $RemoteComputer -Count 1 -Quiet) {

    $ParamHash["Ping"] = "Ok"
                        
    #Check the Firewall            
    if (New-Object Net.sockets.TcpClient($RemoteComputer, 3389)) { 
      $ParamHash["RDPPort"] = "Ok" 
    }
    else { 
      $ParamHash["RDPPort"] = "Failed" 
    }
            
    #Check the Services            
    if ($RDPServices | ForEach-Object { Get-WmiObject Win32_Service -ComputerName $RemoteComputer -Filter "Name = '$($_)' and state = 'Stopped'" }) {
      $ParamHash["RDPServices"] = "Failed"
    }
    else {
      $ParamHash["RDPServices"] = "Ok" 
    }
                       
    #Check the RDP Settings(Enabled\Disabled)
    if ((Get-WmiObject -Class Win32_TerminalServiceSetting -Namespace root\CIMV2\TerminalServices -ComputerName $RemoteComputer -Authentication 6).AllowTSConnections -eq 1) {
      $ParamHash["RDPSettings"] = "Enabled"          
    }
                         
    #Check the RDP NLA Settings	
    if ((Get-WmiObject -class Win32_TSGeneralSetting -Namespace root\cimv2\terminalservices -ComputerName $RemoteComputer -Filter "TerminalName='RDP-tcp'" -Authentication 6).UserAuthenticationRequired -eq 0 ) {
      $ParamHash["RDPwithNLA"] = "Disabled"
                                 
    }
                        
  }
  else {
                      
    $ParamHash["RDPSettings"] = "Failed"
    $ParamHash["RDPwithNLA"] = "Failed"

  }
                              

}
catch {
            
  Write-Host "$RemoteComputer :: $_.Exception.Message" -ForegroundColor Red
  $ParamHash["RDPSettings"] = "Failed"
  $ParamHash["RDPwithNLA"] = "Failed"
}
    
Write-Host ("`t`t`t`RDP Connectivity Check : $RemoteComputer").ToUpper()  -ForegroundColor Green
    
#Format the Output
$length = 0
$ParamHash.Keys | ForEach-Object { if (($_).length -ge $length) { $length = ($_).length } }
$ParamHash.Keys | ForEach-Object { Write-Host "$(($_).PadRight($length,'.'))..................................................$($ParamHash[$_]) " -ForegroundColor Yellow }

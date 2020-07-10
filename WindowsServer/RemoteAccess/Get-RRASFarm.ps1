Function Get-RRASFarm {
  <#
    .SYNOPSIS
    Get active remote connection thru RRAS and RDS Gateway for the specified servers.

    .DESCRIPTION
    This command will query the Win32_TSGatewayConnection class using RPC and root/Microsoft/Windows/RemoteAccess using WinRM 
    and write summary object to the pipeline.

    .PARAMETER ComputerName
    The name of the computer(s) to query. This parameter has an alias of CN. The Input can be piped.

    .EXAMPLE
    PS C:\> Get-RRASFarm VPN01,VPN02,VPN03 | Out-GridView

    UserName                    Server   ConnectedFrom  RemoteAccessType ConnectedResource IdleTime ConnectionDuration RecievedKB SentKB
    --------                    ------   -------------  ---------------- ----------------- -------- ------------------ ---------- ------
    DOMAIN\User1                server1  88.234.211.153 Vpn              10.10.91.194               04:12:14                 3110  20423
    DOMAIN\User2                server2  120.210.33.201 RDP              10.10.90.121      00:00:00 03:37:20                 6162  16504
    DOMAIN\User2                server2  120.210.33.201 Vpn              10.10.91.229               01:16:10                   88      5                     
 
    Formatted results for multiple computers. You can also pipe computer names into this command.
    #>

  Param(
    [Parameter(Position = 0, ValueFromPipeline, ValueFromPipelineByPropertyName)]
    [ValidateNotNullorEmpty()]
    [Alias("cn", "name")]
    [String[]]$ComputerName 
  )

  Write-Verbose "Starting Script"
  ForEach ($computer in $ComputerName) {

    ## We don't use RDP on the RRAS Farm!

    #Try {
    #  #RDP
    #  Write-Verbose "Connecting over RPC to $computer"
    #  [object[]]$wmi_onPC = Get-WmiObject -class "Win32_TSGatewayConnection" -namespace "root\cimv2\TerminalServices" -ComputerName $computer 
    #} # Try $wmi_OnPC RDP 
    #Catch { Write-Warning "Cannot query RDP GW on the host: $computer" }
    #if ($wmi_onPC) {
    #  Write-Verbose "Building object from WMI received from $computer"
    #  ForEach ($wmi in $wmi_onPC) {
    #    [PSCustomObject]@{
    #      UserName           = $wmi.UserName
    #      Server             = $wmi.PSComputerName
    #      ConnectedFrom      = $wmi.ClientAddress
    #      RemoteAccessType   = $wmi.ProtocolName
    #      IdleTime           = (New-TimeSpan -Seconds ($wmi.IdleTime).Substring(0, 14))
    #      ConnectionDuration = (New-TimeSpan -Seconds ($wmi.ConnectionDuration).Substring(0, 14))
    #      ConnectedResource  = $wmi.ConnectedResource
    #      RecievedKB         = $wmi.NumberOfKilobytesReceived
    #      SentKB             = $wmi.NumberOfKilobytesSent
    #    } #end $obj
    #  } # ForEach $wmi
    #  Write-Verbose "Result builded from wmi from $computer"
    #}#end IF $wmi for RDP
    #Else { Write-Verbose "There is no connected RDP GW client on $computer" }

    Try {
      #VPN
      Write-Verbose "Connecting over WMRemote to $computer"
      [object[]]$wmi_onPC = Get-RemoteAccessConnectionStatistics -ComputerName $computer
    } # Try $wmi_OnPC VPN 
    Catch { Write-Warning "Cannot query VPN on the host: $computer" }
    If (($wmi_onPC | Measure-Object).count -gt 0) {
      Write-Verbose "Building object from query results from $computer"
      ForEach ($wmi in $wmi_onPC) {
        [PSCustomObject]@{
          UserName           = $wmi.UserName
          Server             = $computer
          ConnectedFrom      = $wmi.ClientExternalAddress
          RemoteAccessType   = $wmi.ConnectionType
          IdleTime           = ""#(New-TimeSpan -seconds ($wmi.IdleTime).Substring(0,14))
          ConnectionDuration = (New-TimeSpan -Seconds ($wmi.ConnectionDuration))
          ConnectedResource  = $wmi.ClientIPAddress
          RecievedKB         = ([Math]::Round($wmi.TotalBytesIn / 1KB))
          SentKB             = ([Math]::Round($wmi.TotalBytesOut / 1KB))
        } #end $obj
      } # ForEach $wmi
      Write-Verbose "Result builded from query from $computer"
    }# Else IF $wmi count >1
    Else { Write-Verbose "There is no connected VPN client on $computer" }
  } # END ForEach $computer
  Write-Verbose "Jobs done!"
}

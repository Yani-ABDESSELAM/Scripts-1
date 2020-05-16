# Enable Remote Desktop Protocol by Registry Key
Set-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Control\Terminal Server'-name "fDenyTSConnections" -Value 0

# Check if Windows Firewall is configured for Remote Desktop Protocol
$RemoteDesktopFirewall = Get-NetFirewallRule -DisplayGroup "Remote Desktop" | Select-Object -ExpandProperty Enabled

# Add the Windows Firewall exception for Remote Desktop Protocol
If ($RemoteDesktopFirewall -eq 'False') {
  Enable-NetFirewallRule -DisplayGroup "Remote Desktop" -Verbose
}
Else {
  Write-Host "Firewall Rule is already Enabled!"
}

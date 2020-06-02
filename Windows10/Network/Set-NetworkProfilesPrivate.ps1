# Set all Network Profiles to "Private"
# This is to remediate issues with WinRM on devices.
Get-NetConnectionProfile | Where-Object { $_.NetworkCategory -match "Public" } | Set-NetConnectionProfile -NetworkCategory Private

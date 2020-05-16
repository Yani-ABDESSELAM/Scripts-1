# Set all Network Profiles to "Private"
Get-NetConnectionProfile | Where-Object { $_.NetworkCategory -match "Public" } | Set-NetConnectionProfile -NetworkCategory Private

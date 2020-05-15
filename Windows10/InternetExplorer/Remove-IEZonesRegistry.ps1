# Detect incorrect registry keys (HKEY_LOCAL_MACHINE)
Try {
  If ((Get-Item -LiteralPath 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\CurrentVersion\Internet Settings\ZoneMap\Domains' -ea SilentlyContinue)) { } else { return $false };
}
Catch { Return $false }
Return $true

# Remove problematic registry keys (HKEY_LOCAL_MACHINE)
If ((Test-Path -LiteralPath "HKLM:\SOFTWARE\Policies\Microsoft\Windows\CurrentVersion\Internet Settings\ZoneMap\Domains") -eq $true) { Remove-Item "HKLM:\SOFTWARE\Policies\Microsoft\Windows\CurrentVersion\Internet Settings\ZoneMap\Domains" -Force -ErrorAction SilentlyContinue };

# Detect incorrect registry keys (HKEY_CURRENT_USER)
Try {
  If ((Get-Item -LiteralPath 'HKCU:\Software\Policies\Microsoft\Windows\CurrentVersion\Internet Settings\ZoneMap\Domains' -Force -ErrorAction SilentlyContinue)) { } else { return $false };
  If ((Get-Item -LiteralPath 'HKCU:\Software\Policies\Microsoft\Windows\CurrentVersion\Internet Settings\ZoneMapKey' -Force -ErrorAction SilentlyContinue)) { } else { return $false };
  If ((Get-Item -LiteralPath 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings\ZoneMap\EscDomains' -Force -ErrorAction SilentlyContinue)) { } else { return $false };
  If ((Get-Item -LiteralPath 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings\ZoneMap\Domains' -Force -ErrorAction SilentlyContinue)) { } else { return $false };
}
Catch { Return $false }
Return $true

# Remove problematic registry keys (HKEY_CURRENT_USER)
If ((Test-Path -LiteralPath "HKCU:\Software\Policies\Microsoft\Windows\CurrentVersion\Internet Settings\ZoneMap\Domains") -eq $true) { Remove-Item "HKCU:\Software\Policies\Microsoft\Windows\CurrentVersion\Internet Settings\ZoneMap\Domains" -Force -ErrorAction SilentlyContinue };
If ((Test-Path -LiteralPath "HKCU:\Software\Policies\Microsoft\Windows\CurrentVersion\Internet Settings\ZoneMapKey") -eq $true) { Remove-Item "HKCU:\Software\Policies\Microsoft\Windows\CurrentVersion\Internet Settings\ZoneMapKey" -Force -ErrorAction SilentlyContinue };
If ((Test-Path -LiteralPath "HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings\ZoneMap\EscDomains") -eq $true) { Remove-Item "HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings\ZoneMap\EscDomains" -Force -ErrorAction SilentlyContinue };
If ((Test-Path -LiteralPath "HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings\ZoneMap\Domains") -eq $true) { Remove-Item "HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings\ZoneMap\Domains" -Force -ErrorAction SilentlyContinue };

# Enable AppX Sideloading in Windows 10

# AllowAllTrustedApps
# start -Wait C:\Windows\System32\reg.exe -ArgumentList 'add HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\AppModelUnlock /v AllowAllTrustedApps /t REG_DWORD /d 1 /f'

$registryPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\AppModelUnlock"

$Name1 = "AllowAllTrustedApps"
$value1 = "1"
New-ItemProperty -Path $registryPath -Name $name1 -Value $value1 -PropertyType DWORD -Force

# AllowDevelopmentWithoutDevLicense
# start -Wait C:\Windows\System32\reg.exe -ArgumentList 'add HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\AppModelUnlock /v AllowDevelopmentWithoutDevLicense /t REG_DWORD  /d 0 /f'

$Name2 = "AllowDevelopmentWithoutDevLicense"
$value2 = "0"

New-ItemProperty -Path $registryPath -Name $name2 -Value $value2 -PropertyType DWORD -Force

Write-Host "Please open the file to read it! This file is not intended to be run!"
return 0
# To repair an AppX application, follow the syntax below

Get-AppXPackage | ForEach-Object {Add-AppxPackage -DisableDevelopmentMode -Register "$($ENV:ProgramFiles)\WindowsApps\APPLICATION_TO_REPAIR\SUBDIRECTORY_SOMETIMES\AppxManifest.xml"}

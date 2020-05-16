# Remove-MicrosoftTeams.ps1
# Description: Removes Microsoft Teams from the device, including all users.

# Removal Machine-Wide Installer - This needs to be done before removing the .exe below!
Get-WmiObject -Class Win32_Product | Where-Object { $_.IdentifyingNumber -eq "{39AF0813-FA7B-4860-ADBE-93B9B214B914}" } | Remove-WmiObject

#Variables
$TeamsUsers = Get-ChildItem -Path "$($ENV:SystemDrive)\Users"

$TeamsUsers | ForEach-Object {
  Try { 
    if (Test-Path "$($ENV:SystemDrive)\Users\$($_.Name)\AppData\Local\Microsoft\Teams") {
      Start-Process -FilePath "$($ENV:SystemDrive)\Users\$($_.Name)\AppData\Local\Microsoft\Teams\Update.exe" -ArgumentList "-uninstall -s"
    }
  }
  Catch { 
    Out-Null
  }
}

# Remove AppData folder for each User $($_.Name).
$TeamsUsers | ForEach-Object {
  Try {
    if (Test-Path "$($ENV:SystemDrive)\Users\$($_.Name)\AppData\Local\Microsoft\Teams") {
      Remove-Item -Path "$($ENV:SystemDrive)\Users\$($_.Name)\AppData\Local\Microsoft\Teams" -Recurse -Force -ErrorAction Ignore
        }
    } Catch {
        Out-Null
    }
}

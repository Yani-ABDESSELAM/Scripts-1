# Filename: Set-BluebeamLicense.ps1

# Author: Cameron Kollwitz <cameron@kollwitz.us>
# Date: 15/05/2020
# Description: Configure the license for Bluebeam Revu on the device
# v0.1 -- Sloppy initial commit -- not tested!

$BBProductKey = ""
$BBSerialKey = ""
$BBYear = ""
# Should be either "register" or "unregister"
$BBParameters = ""

# Update the Device Information in Bluebeam
& "${ENV:ProgramFiles}\Bluebeam Software\Bluebeam Revu\${BBYear}\Pushbutton PDF\PbMngr5.exe" /$BBParameters
# Register Bluebeam Revu (Extreme)
& "${ENV:ProgramFiles}\Bluebeam Software\Bluebeam Revu\${BBYear}\Pushbutton PDF\PbMngr5.exe" /$BBParameters $BBYear.Substring(2) $BBProductKey $BBSerialKey

Start-Process "${ENV:ProgramFiles}\Bluebeam Software\Bluebeam Revu\$BBYear\Pushbutton PDF\PbMngr5.exe" -ArgumentList "/$BBParameters $BBYear.Substring(2) $BBProductKey $BBSerialKey" -verb runAs -WorkingDirectory "${ENV:ProgramFiles}\Bluebeam Software\Bluebeam Revu\$BBYear\Pushbutton PDF" -Verbose

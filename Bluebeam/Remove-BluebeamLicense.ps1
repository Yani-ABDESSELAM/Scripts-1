# File Name:    Remove-BluebeamLicense.ps1
# Description:  Unregister Bluebeam ReVu Applications on the device.
# Author:       Cameron Kollwitz <cameron@kollwitz.us>

$BBArguments = "/unregister"

## I know I can and should use a loop here, but I'm lazy and will do it later! :P

# Unregister Blubeam 2016
Invoke-Command -FilePath "$($ENV:ProgramFiles)\Bluebeam Software\Bluebeam Revu\2016\Pushbutton PDF\PbMngr5.exe" -ArgumentList $BBArguments -Verbose -ErrorAction SilentlyContinue

# Unregister Blubeam 2017
Invoke-Command -FilePath "$($ENV:ProgramFiles)\Bluebeam Software\Bluebeam Revu\2017\Pushbutton PDF\PbMngr5.exe" -ArgumentList $BBArguments -Verbose -ErrorAction SilentlyContinue

# Unregister Blubeam 2018
Invoke-Command -FilePath "$($ENV:ProgramFiles)\Bluebeam Software\Bluebeam Revu\2018\Pushbutton PDF\PbMngr5.exe" -ArgumentList $BBArguments -Verbose -ErrorAction SilentlyContinue

# Unregister Blubeam 2019
Invoke-Command -FilePath "$($ENV:ProgramFiles)\Bluebeam Software\Bluebeam Revu\2019\Pushbutton PDF\PbMngr5.exe" -ArgumentList $BBArguments -Verbose -ErrorAction SilentlyContinue

# Unregister Blubeam 2020
Invoke-Command -FilePath "$($ENV:ProgramFiles)\Bluebeam Software\Bluebeam Revu\2020\Pushbutton PDF\PbMngr5.exe" -ArgumentList $BBArguments -Verbose -ErrorAction SilentlyContinue

# Unregister Blubeam 2021
#Invoke-Command -FilePath "$($ENV:ProgramFiles)\Bluebeam Software\Bluebeam Revu\2021\Pushbutton PDF\PbMngr5.exe" -ArgumentList $BBArguments -Verbose -ErrorAction SilentlyContinue

& "$ENV:ProgramFiles\Bluebeam Software\Bluebeam Revu\2016\Pushbutton PDF\PbMngr5.exe" /unregister

& "$ENV:ProgramFiles\Bluebeam Software\Bluebeam Revu\2017\Pushbutton PDF\PbMngr5.exe" /unregister

& "$ENV:ProgramFiles\Bluebeam Software\Bluebeam Revu\2018\Pushbutton PDF\PbMngr5.exe" /unregister

& "$ENV:ProgramFiles\Bluebeam Software\Bluebeam Revu\2019\Pushbutton PDF\PbMngr5.exe" /unregister

& "$ENV:ProgramFiles\Bluebeam Software\Bluebeam Revu\2020\Pushbutton PDF\PbMngr5.exe" /unregister

#& "$ENV:ProgramFiles\Bluebeam Software\Bluebeam Revu\2021\Pushbutton PDF\PbMngr5.exe" /unregister

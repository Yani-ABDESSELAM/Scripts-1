:: This Script will reset Internet Explorer to Default Settings
:: A reboot is required to complete this and will proceed after 120 seconds!

:: Reset Settings (Case-Sensitive!)
rundll32 inetcpl.cpl ResetIEtoDefaults

:: Restart the device with a two minute delay
shutdown /r /t 120 /f

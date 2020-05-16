# This script will detect if the defined Print Server is found connected to the device

#Replace OLDPRINTSERVER with name of the Print Server
$OldPrintServer = "\\PRINTSERVERNAME"

# Grab all installed printers on the device
$Printers = Get-WmiObject -Class Win32_Printer

# Check all installed printers for the old print server
ForEach ($Printer in $Printers) {
  If ($Printer.SystemName -like "$OldPrintServer" ) {
    $Compliance = "DETECTED"
} Else { Out-Null }
}
$Compliance

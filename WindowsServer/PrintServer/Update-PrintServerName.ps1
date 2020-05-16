<#
.SYNOPSIS
Find-and-Replace Print Server Hostnames

.DESCRIPTION
This script will update the Print Server mapping on a device to point to a different server which has the same-named printers.

.NOTES
Notes? HA!
#>

Param (
  $newPrintServer = "PS01",
  $oldPrintServers = @("PS00", "PRINTSERVERNAME"),
  $PrinterLog = "\\DOMAIN.TLD\Logs$\PrintMigration.csv"
)

<#
# It is best that this is created before-hand. Just run the 
#Header for CSV log file:
    "COMPUTERNAME,USERNAME,PRINTERNAME,RETURNCODE-ERRORMESSAGE,DATETIME,STATUS" | 
        Out-File -FilePath $PrinterLog -Encoding ASCII
#>

#Pull the current default printer's name
$defaultPrinter = Get-WmiObject win32_printer | Where-Object { $_.Default -eq $true }

#Enable Verbose output (will be reverted at the end of script)
$oldverbose = $VerbosePreference
$VerbosePreference = "continue"

#Change the printer from old to new
Function ChangePrinter {
  Try {
    ForEach ($printer in $printers) {
      Write-Verbose ("{0}: Replacing with new print server name: {1}" -f $Printer.Name, $newPrintServer)
      $newPrinter = $printer.Name -replace $oldPrintServer, $newPrintServer
      $returnValue = ([wmiclass]"Win32_Printer").AddPrinterConnection($newPrinter).ReturnValue
      If ($returnValue -eq 0) {
        "{0},{1},{2},{3},{4},{5}" -f $Env:COMPUTERNAME,
        $env:USERNAME,
        $newPrinter,
        $returnValue,
        (Get-Date),
        "Added Printer" | Out-File -FilePath $PrinterLog -Append -Encoding ASCII
        Write-Verbose ("{0}: Removing" -f $printer.name)
        $printer.Delete()
        "{0},{1},{2},{3},{4},{5}" -f $Env:COMPUTERNAME,
        $env:USERNAME,
        $printer.Name,
        $returnValue,
        (Get-Date),
        "Removed Printer" | Out-File -FilePath $PrinterLog -Append -Encoding ASCII
      }
      Else {
        Write-Verbose ("{0} returned error code: {1}" -f $newPrinter, $returnValue) -Verbose
        "{0},{1},{2},{3},{4},{5}" -f $Env:COMPUTERNAME,
        $env:USERNAME,
        $newPrinter,
        $returnValue,
        (Get-Date),
        "Error Adding Printer" | Out-File -FilePath $PrinterLog -Append -Encoding ASCII
      }
    }

    # Gets new list of printers that are pointed to newserver
    $newPrinterList = @(Get-WmiObject -Class Win32_Printer -Filter "SystemName='\\\\$newPrintServer'" -ErrorAction Stop)
    # iterates through each new printer and compares the ShareName to the old ShareName that was the user’s default printer and sets it
    ForEach ($printer in $newPrinterList) {
      If ($printer.ShareName -eq $defaultPrinter.ShareName) {
        $tmp = $printer.SetDefaultPrinter()
        Write-Verbose ("{0} Set as default printer" -f $printer.Name, $returnValue) -Verbose
        "{0},{1},{2},{3},{4},{5}" -f $Env:COMPUTERNAME,
        $env:USERNAME,
        $printer.Name,
        $returnValue,
        (Get-Date),
        "Set defaultPrinter" | Out-File -FilePath $PrinterLog -Append -Encoding ASCII
      }
    }
  }
  Catch {
    "{0},{1},{2},{3},{4},{5}" -f $Env:COMPUTERNAME,
    $env:USERNAME,
    "WMIERROR",
    $_.Exception.Message,
    (Get-Date),
    "Error Querying Printers" | Out-File -FilePath $PrinterLog -Append -Encoding ASCII
  }
}

#Main Code-Block
Try {
  #ForEach Server in $oldPrintServers do
  ForEach ($oldPrintServer in $oldPrintServers) {
    Write-Verbose ("{0}: Checking for printers mapped to old print server {1}" -f $Env:USERNAME, $oldPrintServer)
    $printers = @(Get-WmiObject -Class Win32_Printer -Filter "SystemName='\\\\$oldPrintServer'" -ErrorAction Stop)
    #If we get back any mapped printer call ChangePrinter and do it
    If ($printers.count -gt 0) {
      ChangePrinter
    }
  }
}
Catch {
  "{0},{1},{2},{3},{4},{5}" -f $Env:COMPUTERNAME,
  $env:USERNAME,
  "WMIERROR",
  $_.Exception.Message,
  (Get-Date),
  "Error Querying Printers" | Out-File -FilePath $PrinterLog -Append -Encoding ASCII
}

$VerbosePreference = $oldverbose

<#
Source: https://gallery.technet.microsoft.com/Script-to-Add-Printers-in-ce8c13cf

This script can be used to add list of printers with Security Groups in Item-Level targetting in GPO

This script will directly edit the printer.xml file of the GPO. hence it will also take the backup of the GPO before editing. This script can be used to edit only one GPO at a time.

Please note:

1. You need to add one printer manually in the GPO so that the Script can clone the entry and add the printers as per the input list. 

2. This script is prepared to add only shared Printers, To add Local or TCP/IP printer you can use the same logic. However you need to make slight changes in the script. the type of printer is identified by GUID as given below. 

SharedPrinter {9A5E9697-9095-436d-A0EE-4D128FDFBCE5}
PortPrinter   {C3A739D2-4A44-401e-9F9D-88E5E77DFB3E}
LocalPrinter  {F08996D5-568B-45f5-BB7A-D3FB1E370B0A}
#>

$InputFilePath = Read-Host "Provide the Path of the inputfile without ("")"
$Inputlist = Import-Csv $InputFilePath
$GPOName = $inputlist.GPOName | Select-Object -Unique

$FDRDatum = (Get-Date).tostring("yyyyMMdd")
# Provide Backup Folder path, the script will create a sub folder with current date.

$GPOBackupFDR = "C:\Temp\$FDRDatum"

If (!(Test-Path $GPOBackupFDR))
{
    New-Item -ItemType Directory -Path $GPOBackupFDR
}

If (($GPOName).Count -eq 1)
{
    $GPOID = Get-GPO $GPOName | Select-Object ID
    Backup-GPO $GPOName -path $GPOBAckupFDR 
    # Provide the Network path of any DC to access the "Printer.xml" file. "Inly change the "\\DC01\d$\" as per your environment. Rest remains same.
    $GPP_PRT_XMLPath = "\\DC01\d$\SYSVOL\domain\Policies\" + "{" + $GPOID.ID + "}" + "\User\Preferences\Printers\Printers.xml"
    [XML]$PRNT = (Get-Content -Path $GPP_PRT_XMLPath) 
        
    foreach ($e in  $Inputlist)
    {
        $CurrentDateTime = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
        $newguid = [System.Guid]::NewGuid().toString()
        $NewEntry = $PRNT.Printers.SharedPrinter[0].Clone() 
        $NewEntry.Name = $e.Name
        $NewEntry.Status = $e.Name 
        $NewEntry.Changed = "$CurrentDateTime"
        $NewEntry.uid = "{" + "$newguid" + "}"
        $NewEntry.userContext = $e.UserContext 
        $NewEntry.properties.path = $e.Path
        $NewEntry.properties.action = $e.action
        $NewEntry.filters.Filtergroup.Name = $e.GroupName 
        $NewEntry.filters.Filtergroup.SID = $e.GroupSID 
        $PRNT.DocumentElement.AppendChild($NewEntry) 
    } 

    $PRNT.Save($GPP_PRT_XMLPath)
}

Else { Write-Host -ForegroundColor Red "ERROR: GPOName not unique" }

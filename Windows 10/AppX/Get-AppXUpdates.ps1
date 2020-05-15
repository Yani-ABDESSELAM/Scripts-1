<#
.SYNOPSIS
  Updates all Universal Windows Applications (UWP) AppX packages on the device.

.DESCRIPTION
  Updates all Universal Windows Applications (UWP) AppX packages on the device.

  This is the equivilent of clicking "Check for Updates" within the Microsoft Store application.

  NOTE: This script DOES NOT WAIT for the updates to complete before returning. There does not appear to be any way to return "completed" information other than verifying directly in the Micorosft Store.

.NOTES
  Author:   Cameron Kollwitz
  Date:     January 02, 2020
  Email:    cameron@kollwitz.us
  License:  GNU Public License v3

.NOTES
  This can also be run as a one-liner:

    Get-CimInstance -Namespace "Root\cimv2\mdm\dmmap" -ClassName "MDM_EnterpriseModernAppManagement_AppManagement01" -Verbose | Invoke-CimMethod -MethodName UpdateScanMethod -Verbose

#>

# AppX WMI Namespace
$namespaceName = "root\cimv2\mdm\dmmap"

# AppX Class Name
$className = "MDM_EnterpriseModernAppManagement_AppManagement01"

# Grab the AppX package and update it.
$wmiObj = Get-WmiObject -Namespace $namespaceName -Class $className

# Retun Results
$result = $wmiObj.UpdateScanMethod()

$result

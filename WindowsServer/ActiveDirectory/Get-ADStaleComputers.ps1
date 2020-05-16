#requires ActiveDirectory

# Author:       Cameron Kollwitz
# Date:         12/02/2019
# Filename:     Get-ADStaleComputers.ps1
# Description:  Scan Active Directory for "stale" computer objects and dump them to a CSV for analysis.

# Define Domain
$domain = "domain.tld"

# Define how many days of inactivity within Active Directory should be considered "stale"
$DaysInactive = 90

# OUTTATIME
$time = (Get-Date).Adddays(-($DaysInactive))

# MAIN SCRIPT
# Version 1.0
#Get-ADComputer -Filter {LastLogonTimeStamp -lt $time} -ResultPageSize 2000 -resultSetSize $null -Properties Name, OperatingSystem, SamAccountName, DistinguishedName | Export-CSV "" -NoTypeInformation -Verbose

# Version 2.0
# Get all AD computers with lastLogonTimestamp less than our time 
Get-ADComputer -Filter {LastLogonTimeStamp -lt $time} -Properties LastLogonTimeStamp | 
# Select the Objects that want to display in the output
Select-Object Name,@{Name="Stamp"; Expression={[DateTime]::FromFileTime($_.lastLogonTimestamp)}} | 
# Output Device Name and lastLogonTimestamp to CSV
Export-Csv "C:\Temp\ADComputers-Stale-Devices.csv" -NoTypeInformation


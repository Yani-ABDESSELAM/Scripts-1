## Must be run from each Domain Controller. NTFS permissions on this file must allow Read & Execute for each DC's computer object,
## and Modify access to the \Locked Out folder.
## Will export to text file list of current locked out users and the machines that last sent the bad password

Import-Module activedirectory

$DT = [DateTime]::Now.AddHours(-6)
$logName = '{0}LockoutReport.txt' -f "\\server\Reports\" #, $DT.tostring("yyyy-MM-dd")

#Check the log file
$logfile = gci $logName -ErrorAction SilentlyContinue
if ($logfile -eq $null -or (Get-Date).AddMinutes(-15) -gt $logfile.CreationTime) { #If the log is missing, or >15 minutes old, write the header:
    $logfile.CreationTime = Get-Date
    (Get-Date).ToString()+"`t"+$(Hostname) | Out-File -FilePath $logName -Encoding UTF8
    #Generate list of locked out accounts
    $locked = Search-ADAccount -LockedOut -Server $(hostname) | FT -Property Name,LockedOut,Enabled,PasswordExpired,LastLogonDate -AutoSize | Out-String
    if ($locked -eq "") { $locked = "No locked out accounts found on $(hostname).`r`n" }
    $locked | Out-File -FilePath $logname -Append -Encoding UTF8
}

$eventlog = Get-EventLog -LogName 'Security' -InstanceId 4740 -After $DT |
        Select-Object @{
        Name='UserName'
        Expression={$_.ReplacementStrings[0]}
        },
        @{
        Name='WorkstationName'
        Expression={$_.ReplacementStrings[1] -replace '\$$'}
        },TimeGenerated | Out-String
$(Hostname) | Out-File -FilePath $logName -Append -Encoding UTF8
If ($eventlog -eq "" -or $eventlog -eq $null) { $eventlog = "No lockout events.`r`n" }
$eventlog | Out-File -FilePath $logName -Append -Encoding UTF8


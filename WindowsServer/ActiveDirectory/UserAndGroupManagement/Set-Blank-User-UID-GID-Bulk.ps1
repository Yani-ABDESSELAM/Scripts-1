function Set-RandomUserUIDAndGID {
    <#
    .SYNOPSIS
    This script will set the uidnumber and gidnumber LDAP attributes to a unique value for users in Active Directory.
    .DESCRIPTION
    The Set-ADUser cmdlet is used to set LDAP attributes on an Active Directory user. This function will run and add the gidnumber and
    uidnumber attributes where they are empty. These attributes are used for Unix systems. The formula to generating this value ensures
    a unique value for each user.
    #>
    param
    (
        [datetime]$date,
        [array]$users,
        [string]$logpath
    )
    begin {
        # Get current date and format it in short-date and short-time format
        $date = (Get-Date -Format G)
        $logpath = # if running as script: "<static log path>" or if running live: "Read-Host "What is the path you would like to set for logs?""
        Write-Output "Starting Script - $date" >> $logpath
    }
    process {
        # Gets Active Directory users with no current UID set
        $users = (Get-ADUser -Properties * -Filter * | Where-Object  {$_.uidnumber -eq $null})
        # Begin FOR loop for each user found
        ForEach($user in $users) {
            # Set $UID based on user SID formula to ensure a unique number for all users
            $UID = ($User.SID | findstr -i S-).split("{-}")[13]
            #Set the uidnumber variable based on $UID variable
            Set-ADUser $user -Replace @{uidnumber=$UID}
            #Set the gidnumber attribute based on $UID variable
            Set-ADUser $user -Replace @{gidnumber=$UID}
            # Optional - set shell to /bin/bash - remove comment on line below to use
            # Set-ADUser -Replace @{loginshell="/bin/bash"}  	   
        }
    }
    end {
        Write-Output "Script Complete - $date" >> $logpath
    }
}

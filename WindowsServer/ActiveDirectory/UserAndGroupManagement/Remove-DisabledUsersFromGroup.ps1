function Remove-DisabledUsersFromGroup {
    <#
    .SYNOPSIS
    This script will remove disabled AD users from an AD group that they are still members of.
    .DESCRIPTION
    The Remove-ADGroupMember cmdlet removes AD group members from an AD group. This function lets you remove all disabled users from a
    targeted AD group and it sends a log file to your specified path. *Note - typically this cmdlet prompts for confirmation on each
    removal, but that is being bypassed with the "-Confirm:$false" command on line 27
    #>
    [CmdletBinding()]
    param
    (
    [string]$group,
    [string]$logPath,
    [array]$users
    )
    begin {
        $group = ""
        $logPath = ""
    }
    process {
        $users = Get-ADGroup $group | Get-ADGroupMember | Get-ADUser -Properties department, enabled

        ForEach($user in $users){
            If($user.enabled -eq $false) {
                Write-Output "$user.name has been removed from the $group group" | Out-File $logPath -Append
                Remove-ADGroupMember -Identity $group -Members $user -Confirm:$false
            }
        }
    }
}
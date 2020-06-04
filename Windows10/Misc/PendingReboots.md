Check if you've got a pending file rename interfering with your desired operation:
REG QUERY "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager" /v PendingFileRenameOperations

If you do, and you're sure you know what you're doing:
REG DELETE "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager" /v PendingFileRenameOperations /f


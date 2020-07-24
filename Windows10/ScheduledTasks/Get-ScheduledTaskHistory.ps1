Get-ScheduledTask | Where-Object state -EQ 'ready' | Get-ScheduledTaskInfo |
Export-Csv -NoTypeInformation -Path D:\scheduledTasksResults.csv
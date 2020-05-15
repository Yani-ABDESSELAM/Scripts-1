$Users = ForEach ($user in $(Get-Content D:\Temp\Users.txt)) { Get-AdUser $user -Properties * }
$Users | Select-Object * | Export-CSV -Path D:\Temp\Output.csv -NoTypeInformation

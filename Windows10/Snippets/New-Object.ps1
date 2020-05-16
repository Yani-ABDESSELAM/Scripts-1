# Create a New Object
$Result = New-Object -TypeName PSObject
Add-Member -InputObject $Result -MemberType NoteProperty -Name Parameter1 -Value Result1
Add-Member -InputObject $Result -MemberType NoteProperty -Name Parameter2 -Value Result2
Return $Result

##############################################################################################

# Create a New Object
$Results = @()

ForEach ($Line in $Lines) {
  $Result = New-Object -TypeName PSObject
  Add-Member -InputObject $Result -MemberType NoteProperty -Name Parameter1 -Value $Line.Result1
  Add-Member -InputObject $Result -MemberType NoteProperty -Name Parameter2 -Value $Line.Result2
  $Results += $Result
}

Return $Results
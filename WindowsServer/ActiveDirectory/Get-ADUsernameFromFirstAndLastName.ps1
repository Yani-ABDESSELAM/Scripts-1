# Get-ADUserNameFromFirstAndLastName.ps1
# The first line of the CSV file must match the filters used!

$Names = Import-Csv "$PSScriptRoot\Get-ADUserNameFromFirstAndLastName.csv" -Header GivenName, Surname -Delimiter ";"
ForEach ($Name in $Names) {
  $FirstFilter = $Name.GivenName
  $SecondFilter = $Name.Surname
  Get-ADUser -Filter { GivenName -like $FirstFilter -and Surname -like $SecondFilter } -Properties EmailAddress | Select-Object EmailAddress
}

Import-Csv -Path $PSScriptRoot\first-and-last-names.csv | 
  ForEach-Object{
    Get-ADUser -Filter "GivenName -eq '$($_.FirstName)' -and Surname -eq '$($_.LastName)'" -Properties emailAddress
  } |
  Select-Object Name, emailAddress, SamAccountName, GivenName, Surname

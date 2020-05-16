# Author: Cameron Kollwitz
# This script toggles the "This Account Must Change Its Password Next Time It Signs In" switch in Active Directory.

Import-Csv "D:\Scripts\Uncheck-Please.csv" | ForEach-Object { 
  $samAccountName = $_."samAccountName"
  Get-ADUser -Identity $samAccountName | 
  Set-ADUser -ChangePasswordAtLogon:$false -Verbose
}
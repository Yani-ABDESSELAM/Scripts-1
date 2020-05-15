# Create a SecurityIdentifier object and translate into a NTAccount

$InputSID = Read-Host -Prompt 'Input SID to convert to Username'
$objSID = New-Object System.Security.Principal.SecurityIdentifier ("$InputSID")
$objUser = $objSID.Translate( [System.Security.Principal.NTAccount])
$objUser.Value

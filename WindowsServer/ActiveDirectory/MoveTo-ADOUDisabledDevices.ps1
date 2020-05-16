return 0
# Quick One-liner to Move Devices in Active Directory
# Use -Filter to exclude OUs!

Get-ADComputer -LDAPFilter "(&(objectCategory=computer)(objectClass=computer)(useraccountcontrol:1.2.840.113556.1.4.803:=2))" | Move-ADObject -TargetPath "OU=AD Cleanup,OU=Disabled Computers,DC=DOMAIN,DC=com" -Verbose -WhatIf
(&(objectClass=user)(!(distinguishedName:=%Servers%)))

(&(objectCategory=computer)(userAccountControl:1.2.840.113556.1.4.803:=2)(!(distinguishedName:="%OU=Disabled Computers,DC=DOMAIN,DC=com%"))(!(distinguishedName:="%OU=Servers,DC=DOMAIN,DC=com%"))(!(distinguishedName:="%OU=Servers - VMWare,DC=DOMAIN,DC=com%"))(!(distinguishedName:="%OU=Servers Auto Windows Update,DC=DOMAIN,DC=com%")))

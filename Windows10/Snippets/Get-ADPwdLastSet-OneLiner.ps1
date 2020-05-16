Get-ADUser $USER -Properties lastlogontimestamp,pwdLastSet | Select-Object samaccountname, `
  @{Name="LastLogonTimeStamp";Expression={([datetime]::FromFileTime($_.LastLogonTimeStamp))}},`
  @{Name="pwdLastSet";Expression={([datetime]::FromFileTime($_.pwdLastSet))}}

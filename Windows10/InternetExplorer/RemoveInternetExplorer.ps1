return 0 # Just in case the file is accidentally run!

# Check for Internet Explorer
Get-WindowsOptionalFeature -Online | Select-Object FeatureName | Select-String Internet*

# Disable Internet Explorer
Disable-WindowsOptionalFeature -FeatureName Internet-Explorer-Optional-amd64 -Online

# Remotely Check for Internet Explorer
Invoke-Command -ComputerName $TARGET -ScriptBlock { Get-WindowsOptionalFeature -Online } | Select-Object FeatureName | Select-String Internet*

# Remotely Disable Internet Explorer
Invoke-Command -ComputerName $TARGET -ScriptBlock { Disable-WindowsOptionalFeature -FeatureName Internet-Explorer-Optional-amd64 -Online }

return 0

# Use the following command structure to provision an AppX package in the WIM
# More Info: https://docs.microsoft.com/en-us/windows-hardware/manufacture/desktop/dism-app-package--appx-or-appxbundle--servicing-command-line-options/

# Use when there is no special license attached to the deployment!

dism.exe /Online /Add-ProvisionedAppxPackage /PackagePath:C:\Temp\WavesAudio.MaxxAudioProforDell2019_2.0.54.0_neutral___fh4rh281wavaa.appxbundle /SkipLicense /NoRestart


# If the application is licensed, ensure you specify the XML file for the license!

dism.exe /Online /Add-ProvisionedAppxPackage /PackagePath:C:\Temp\WavesAudio.MaxxAudioProforDell2019_2.0.54.0_neutral___fh4rh281wavaa.appxbundle /LicensePath:C:\Temp\WavesAudio.MaxxAudioProforDell2019_fh4rh281wavaa_8b7dee73-f147-d20e-9d2e-cf4181c34ccb.xml /NoRestart

# Remove a provisioned AppX package
# NOTE: This will only work with pacakages that have been provisioned using the method(s) above!
# Retreive the PackageName with `Get-ProvisionedAppxPackage -Online | Select-Object -Property DisplayName` cmdlet!

Dism.exe /Online /Remove-ProvisionedAppxPackage /PackageName:WavesAudio.MaxxAudioProforDell2019 /NoRestart

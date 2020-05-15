# Autodesk Genuine Service Fix for Autodesk Uninstall
# ONLY use when needed!

[string[]]$ProfilePaths = Get-UserProfiles -ExcludeSystemProfiles:$True | Select-Object -ExpandProperty 'ProfilePath'
foreach ($uPath in $ProfilePaths) {
  $idDatPath = Join-Path -Path $uPath -ChildPath "AppData\Local\Autodesk\Genuine Autodesk Service\id.dat"
  if (Test-Path $idDatPath) {
    Write-Log -Message "Found ""$($idDatPath)"". Removing..." -LogType CMTrace -Source "dinci5"
    Remove-File -Path $idDatPath
  }
}

$AGSProductCode = (Get-InstalledApplication "Autodesk Genuine Service").ProductCode
if ($AGSProductCode) {
  $AGSProductCode = $AGSProductCode.Trim()
  Execute-MSI -Action 'Uninstall' -Path $AGSProductCode -ContinueOnError $true
}

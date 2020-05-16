<#
.EXAMPLE
  Uninstall-HotFix -ComputerName PC1 -HotfixID KB123456
#>

Function Uninstall-WUSAHotfix {
  [cmdletbinding()]
  Param(
    $ComputerName = $env:computername,
    [string] $HotfixID
  )

  $hotfixes = Get-WmiObject -ComputerName $computername -Class Win32_QuickFixEngineering | Select-Object hotfixid

  If ($hotfixes -match $hotfixID) {
    $hotfixID = $HotfixID.Replace("KB", "")
    Write-host "Found hotfix" + $HotfixID
    Write-Host "Uninstalling hotfix..."
    $UninstallString = "cmd.exe /c wusa.exe /uninstall /KB:$hotfixID /quiet /norestart"
    ([WMICLASS]"\\$computername\ROOT\CIMV2:win32_process").Create($UninstallString) | Out-Null
    While (@(Get-Process wusa -computername $computername -ErrorAction SilentlyContinue).Count -ne 0) {
      Start-Sleep 3
      Write-Host "Waiting for update removal to finish ..."
    }
    write-host "Completed removal of $hotfixID"
  }
  Else {
    Write-Host "Given hotfix($hotfixID) not found"
    Return
  }
}

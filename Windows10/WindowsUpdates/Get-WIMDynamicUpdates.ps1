<#
.SYNOPSIS
  Service your Windows WIM with monthly updates.

.DESCRIPTION
  Download Dynamic Updates from Microsoft using SCCM Catalog

.NOTES
  Version 1.X Author: Adam Gross
  Twitter: @AdamGrossTX

  Version 2.X Author: Cameron Kollwitz
  cameron@kollwitz.us

.LINK
  https://github.com/AdamGrossTX/PowershellScripts/blob/master/Windows%2010%20Servicing/Get-DynamicUpdates.ps1

.HISTORY
  1.0 - Original
  1.1 - Added logic to export XML file list. Added logic to loop through OS Version if No OSVersion or OSArch is selected
  1.2 - Added logic to export .JSON files as well. You're welcome @SeguraOSD!!
  1.3 - Changed Property sort order for readability and added KBInfoURL. Removed Month param and collapsed folder structure to \version-arch instead of \version\month\arch\
  1.4 - Fixed Typo and Parameter Validation
  1.5 - Added fix for 2018-09 SetupUpdates not being classified correctly.
  1.6 - Corrected logic for ALL Updates
  1.7 - Updated Params to remove Mandatory
  1.8 - Minor Updates.
  ---
  2.0 - Update Function Verb, formatting for 2-space indentations, removal of PowerShell aliases, updated nominclature for Configuration Manager as it is no longer "SCCM". Updated Default Servicing Directory. Added 1909 to Parameter switch.
#>

Param (
  [Parameter(HelpMessage = "Operating System version to service. (Default is ALL)")]
  [ValidateSet('1511', '1607', '1703', '1709', '1803', '1809', '1903', '1909', 'Next', 'ALL')]
  [ValidateNotNullOrEmpty()]
  [string]
  $OSVersion = "All",

  [Parameter(HelpMessage = "Architecture version to service. (Default is ALL)")]
  [ValidateSet ('x64', 'x86', 'ARM64', 'All')]
  [ValidateNotNullOrEmpty()]
  [string]
  $OSArch = "All",

  [Parameter(HelpMessage = "Path to working directory for servicing data. Default is C:\~CMImageServicing.")]
  [ValidateNotNullOrEmpty()]
  [string]
  $RootFolder = "C:\~CMImageServicing",

  [Parameter(HelpMessage = "ConfigMgr Primary Server Name.")]
  [ValidateNotNullOrEmpty()]
  [string]
  $SCCMServer = $null,

  [Parameter(HelpMessage = "ConfigMgr Site Code.")]
  [ValidateNotNullOrEmpty()]
  [string]
  $SiteCode = $null,

  #Use this to download updates. Set to false to just generate the files list(s)
  [Switch]
  $DownloadUpdates = [switch]::Present,

  #Use this to download updates. Set to false to just generate the files list(s)
  [Switch]
  $ExcludeSuperseded = [switch]::Present
)

If ([string]::IsNullOrEmpty($SCCMServer)) {
  $SCCMServer = Read-Host -Prompt 'Input ConfigMgr Primary Server Name'
}
If ([string]::IsNullOrEmpty($SiteCode)) {
  $SiteCode = Read-Host -Prompt 'Input ConfigMgr Site Code'
}

$Script:MasterList = @()
$OSVersionList = @('1511', '1607', '1703', '1709', '1803', '1809', '1903', '1909', 'Next')
$OSArchList = @('x86', 'x64', 'ARM64')
$AllDynamicUpdatesFilter = 'LocalizedCategoryInstanceNames = "Windows 10 Dynamic Update"'
$AllDynamicUpdates = Get-WmiObject -ComputerName $SCCMServer -Class SMS_SoftwareUpdate -Namespace "root\SMS\Site_$($SiteCode)" -Filter $AllDynamicUpdatesFilter

Function Start-CMImageServicing ($OSVersion, $OSArch) {
  Write-Host "Processing $($OSVersion)-$($OSArch)"  -ForegroundColor Green
  If ($DownloadUpdates) {
    $UpdatesPath = "$($RootFolder)\Updates\$($OSVersion)-$($OSArch)"
    $DUSUPath = "$($UpdatesPath)\SetupUpdate"
    $DUCUPath = "$($UpdatesPath)\ComponentUpdate"

    if (!(Test-Path -path $DUSUPath)) { New-Item -path $DUSUPath -ItemType Directory }
    if (!(Test-Path -path $DUCUPath)) { New-Item -path $DUCUPath -ItemType Directory }
  }

  $DownloadList = @()
  $DisplayNameFilter = "*$($OSVersion)*$($OSArch)*"

  If ($ExcludeSuperseded) {
    $FilteredUpdateList = $AllDynamicUpdates | Where-Object { $_.LocalizedDisplayName -like $DisplayNameFilter -and $_.IsSuperseded -eq $False -and $_.IsLatest -eq $True }
  }
  Else {
    $FilteredUpdateList = $AllDynamicUpdates | Where-Object { $_.LocalizedDisplayName -like $DisplayNameFilter }
  }

  ForEach ($Update in $FilteredUpdateList) {
    $ContentIDs = Get-WmiObject -ComputerName $SCCMServer -Class SMS_CIToContent -Namespace "root\SMS\Site_$($SiteCode)" -Filter "CI_ID = $($Update.CI_ID)"
    ForEach ($ContentID in $ContentIDs) {
      $Content = Get-WmiObject -ComputerName $SCCMServer -Class SMS_CIContentFiles -Namespace "root\SMS\Site_$($SiteCode)" -Filter "ContentID = $($ContentID.ContentID)"
      $DownloadList += New-Object PSObject -Property:@{
        'KB'          = $Update.ArticleID;
        #'CI_ID' = $Update.CI_ID;
        'DisplayName' = $Update.LocalizedDisplayName;
        #'ContentID' = $ContentIDs.ContentID;
        'FileName'    = $Content.FileName;
        'URL'         = $Content.SourceURL;
        'KBInfoURL'   = $Update.LocalizedInformativeURL;
        'Type'        = If (($Update.ArticleID -eq "4457190") -or ($Update.ArticleID -eq "4457189")) { "SetupUpdate" } Else { $Update.LocalizedDescription.Replace(":", "") }
        'SuperSeded'  = $Update.IsSuperseded
      }
    }
  }

  ForEach ($File in $DownloadList) {
    $Path = $null
    #Fix for September SetupUpdate not containing the correct text to classify propery!
    If ($File.FileName -like "*KB4457190*" -or $File.FileName -like "*KB4457189*") {
      $Path = "$($DUSUPath)\$($File.FileName)"
    }
    Else {
      switch ($File.Type) {
        SetupUpdate { $Path = "$($DUSUPath)\$($File.FileName)"; break; }
        ComponentUpdate { $Path = "$($DUCUPath)\$($File.FileName)"; break; }
        Default { $Path = "$($UpdatesPath)\$($File.FileName)"; break; }
      }
    }

    If ($DownloadUpdates) {
      Write-Host $Path -ForegroundColor Green
      Invoke-WebRequest -Uri $File.URL -OutFile $Path
    }
  }

  If ($DownloadList) {
    $DownloadList | Sort-Object -Property Type, KB | Select-Object KB, DisplayName, KBInfoURL, Type, FileName, URL | Export-Clixml -Path "$($RootFolder)\$($OSVersion)-$($OSArch)-Windows10DynamicUpdateList.XML"
    $DownloadList | Sort-Object -Property Type, KB | Select-Object KB, DisplayName, KBInfoURL, Type, FileName, URL | ConvertTo-Json | Out-File "$($RootFolder)\$($OSVersion)-$($OSArch)-Windows10DynamicUpdateList.json"
    $Script:MasterList += $DownloadList
  }
}

### PRIMARY SCRIPT LOOP ###

If ($OSVersion -eq 'ALL' -and $OSArch -eq 'ALL') {
  ForEach ($Version in $OSVersionList) { 
    ForEach ($Arch in $OSArchList) { 
      Start-CMImageServicing $Version $Arch
    }
  }
}
ElseIf ($OSVersion -eq 'ALL') {
  ForEach ($Version in $OSVersionList) { 
    Start-CMImageServicing $Version $OSArch
  }
}
ElseIf ($OSArch -eq 'ALL') {
  ForEach ($Arch in $OSArchList) { 
    Start-CMImageServicing $OSVersion $Arch
  }
} 
Else {
  Start-CMImageServicing $OSVersion $OSArch
}

$Script:MasterList | Sort-Object -Property Type, KB | Select-Object KB, DisplayName, KBInfoURL, Type, FileName, URL | Export-Clixml -Path "$($RootFolder)\All-Windows10DynamicUpdateList.XML"
$Script:MasterList | Sort-Object -Property Type, KB | Select-Object KB, DisplayName, KBInfoURL, Type, FileName, URL | ConvertTo-Json | Out-File "$($RootFolder)\All-Windows10DynamicUpdateList.json"

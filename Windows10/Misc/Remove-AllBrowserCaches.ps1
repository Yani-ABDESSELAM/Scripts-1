<#
.SYNOPSIS
  This script clears the User's browser caches.

.DESCRIPTION
  Removes the cache, thumbnails, cookies, etc. for: Mozilla Firefox, Google Chrome, Microsoft Edge (Version 75+), and Internet Explorer.
  Intended to be run from Software Center as an application deployment!

.NOTES
  Author:       Cameron Kollwitz
  Date:         01/17/2020
  Email:        cameron@kollwitz.us
  Filename:     Remove-AllBrowserCaches.ps1
  Version:      1.0
#>

# BEGIN

  # Clear Mozilla Firefox Cache
  Try {
    Remove-Item -Path "$ENV:LOCALAPPDATA\Mozilla\Firefox\Profiles\*\cache\*" -Recurse -Force -EA SilentlyContinue -Verbose
    Remove-Item -Path "$ENV:LOCALAPPDATA\Mozilla\Firefox\Profiles\*\cache2\entries\*" -Recurse -Force -EA SilentlyContinue -Verbose
    Remove-Item -Path "$ENV:LOCALAPPDATA\Mozilla\Firefox\Profiles\*\thumbnails\*" -Recurse -Force -EA SilentlyContinue -Verbose
    Remove-Item -Path "$ENV:LOCALAPPDATA\Mozilla\Firefox\Profiles\*\webappsstore.sqlite" -Recurse -Force -EA SilentlyContinue -Verbose
    Remove-Item -Path "$ENV:LOCALAPPDATA\Mozilla\Firefox\Profiles\*\chromeappsstore.sqlite" -Recurse -Force -EA SilentlyContinue -Verbose
    # Uncomment the lines below if you want to remove cookies as well!
    Remove-Item -Path "$ENV:LOCALAPPDATA\Mozilla\Firefox\Profiles\*\cookies.sqlite" -Recurse -Force -EA SilentlyContinue -Verbose
  } Catch { Write-Error "Mozilla Firefox Cleaning Failed!" }

  # Clear Google Chrome
  Try {
    Remove-Item -Path "$ENV:LOCALAPPDATA\Google\Chrome\User Data\Default\Cache\*" -Recurse -Force -EA SilentlyContinue -Verbose
    Remove-Item -Path "$ENV:LOCALAPPDATA\Google\Chrome\User Data\Default\Cache2\entries\*" -Recurse -Force -EA SilentlyContinue -Verbose
    Remove-Item -Path "$ENV:LOCALAPPDATA\Google\Chrome\User Data\Default\Media Cache" -Recurse -Force -EA SilentlyContinue -Verbose
    # Uncomment the lines below if you want to remove cookies as well!
    Remove-Item -Path "$ENV:LOCALAPPDATA\Google\Chrome\User Data\Default\Cookies" -Recurse -Force -EA SilentlyContinue -Verbose
    Remove-Item -Path "$ENV:LOCALAPPDATA\Google\Chrome\User Data\Default\Cookies-Journal" -Recurse -Force -EA SilentlyContinue -Verbose
  } Catch { Write-Error "Google Chrome Cleaning Failed!" }

  # Clear Internet Explorer
  Try {
    # This path is for Windows 7 and prior
    #Remove-Item -Path "$ENV:LOCALAPPDATA\Microsoft\Windows\Temporary Internet Files\*" -Recurse -Force -EA SilentlyContinue -Verbose
    # This path is for Windows 8/8.1 and above
    Remove-Item -Path "$ENV:LOCALAPPDATA\Microsoft\Windows\INetCache\*" -Recurse -Force -EA SilentlyContinue -Verbose
    Remove-Item -Path "$ENV:LOCALAPPDATA\Microsoft\Windows\WER\*" -Recurse -Force -EA SilentlyContinue -Verbose
    Remove-Item -Path "$ENV:LOCALAPPDATA\Temp\*" -Recurse -Force -EA SilentlyContinue -Verbose
  } Catch { Write-Error "Internet Explorer Cleaning Failed!" }

  # Clear Microsoft Edge
  Try {
    Remove-Item -Path "$ENV:LOCALAPPDATA\Microsoft\Edge\User Data\Default\Cache\*" -Recurse -Force -EA SilentlyContinue -Verbose
    Remove-Item -Path "$ENV:LOCALAPPDATA\Microsoft\Edge\User Data\Default\Cache2\entries\*" -Recurse -Force -EA SilentlyContinue -Verbose
    Remove-Item -Path "$ENV:LOCALAPPDATA\Microsoft\Edge\User Data\Default\Media Cache" -Recurse -Force -EA SilentlyContinue -Verbose
    # Uncomment the lines below if you want to remove cookies as well!
    Remove-Item -Path "$ENV:LOCALAPPDATA\Microsoft\Edge\User Data\Default\Cookies" -Recurse -Force -EA SilentlyContinue -Verbose
    Remove-Item -Path "$ENV:LOCALAPPDATA\Microsoft\Edge\User Data\Default\Cookies-Journal" -Recurse -Force -EA SilentlyContinue -Verbose
  } Catch { Write-Error "Microsoft Edge Cleaning Failed!" }

# END

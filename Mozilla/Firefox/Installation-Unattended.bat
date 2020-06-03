@ECHO OFF
SET "FirefoxFolder="
TITLE Firefox Updater
curl --silent -o "%TEMP%\firefoxdl.txt" "https://download.mozilla.org/?product=firefox-latest-ssl&os=win64&lang=en-US"
POWERSHELL -command "(Get-Content "%TEMP%\firefoxdl.txt") | ForEach-Object { $_ -replace '^.*releases.([0-9][0-9]).*$','$1' } | Set-Content "%TEMP%\firefoxdl.txt""
SET /p FirefoxVersion=<"%TEMP%\firefoxdl.txt"
DEL "%TEMP%\firefoxdl.txt"
ECHO The Latest Release of Firefox is version %FirefoxVersion%.

REM Grab the path of the currently installed version of Firefox from the Windows Registry.
FOR /F "skip=2 tokens=1,2*" %%A in ('%SystemRoot%\System32\reg.exe QUERY "HKLM\Software\Microsoft\Windows\CurrentVersion\App Paths\firefox.exe" /v PATH 2^>NUL') do (
  IF /I "%%A" == "Path" (
    SET "FirefoxFolder=%%C"
    IF DEFINED FirefoxFolder GOTO CheckFirefox
  )
)

:InstallFirefox

:UpdateFireFox
ECHO Downloading Firefox Version %FirefoxVersion%...
curl --silent -L -o "%TEMP%\firefoxcurrent.exe" "https://download.mozilla.org/?product=firefox-latest-ssl&os=win64&lang=en-US"
ECHO Installing Firefox Version %FirefoxVersion%, please wait...
TASKLIST /fi "imagename eq firefox.exe" |find ":" > NUL
IF ERRORLEVEL 1 TASKKILL /f /im "firefox.exe" >NUL 2>&1
START "" /wait "%TEMP%\firefoxcurrent.exe" -ms
ECHO Cleaning Up!
DEL "%TEMP%\firefoxcurrent.exe"
GOTO :EOF

:CheckFirefox
IF not EXIST "%FirefoxFolder%\firefox.exe" GOTO InstallFirefox

REM Check if version of Mozilla Firefox starts with defined number.
REM The space at beginning makes sure to find the major version number.
"%FirefoxFolder%\firefox.exe" -v | %SystemRoot%\System32\more | %SystemRoot%\System32\find.exe " %FirefoxVersion%" >NUL
IF ERRORLEVEL 1 (
  ECHO Updating Firefox to version %FirefoxVersion% ...
  GOTO UpdateFireFox
)

ECHO However, Firefox version %FirefoxVersion% is already installed.

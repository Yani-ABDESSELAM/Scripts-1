:: Autodesk Setup Loop Check
:LOOP1
tasklist | find /i "setup.exe" >nul 2>&1
IF ERRORLEVEL 1 (
GOTO CONTINUE1
) ELSE (
ECHO Autodesk is still being installed
Timeout /T 30 /NOBREAK
GOTO LOOP1
)

:CONTINUE1
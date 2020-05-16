@echo off

:: Author:      Cameron Kollwitz
:: Description: Sets the DCOM Permissions on the Device. Modify as-needed.

set keypath=HKEY_CLASSES_ROOT\AppID
set appid={61738644-F196-11D0-9953-00C04FD919C1}
set appuser=IIS_IUSRS
set keyname=%keypath%\%appid%
set sid_ti=S-1-5-80-956008885-3418522649-1831038044-1853292631-2271478464
set sid_admins=S-1-5-32-544
set workdir=%~dp0

openfiles > nul
if %errorlevel% equ 0 (
	echo [ Set ADMINS as owner and grant full control ]
	%workdir%\setacl -on "%keyname%" -ot reg -actn setowner -ownr "n:%sid_admins%" -silent
	%workdir%\setacl -on "%keyname%" -ot reg -actn ace -ace "n:%sid_admins%;p:full;s:y;i:so,sc;m:set;w:dacl" -silent

	echo [ Set DCOM permissions ]
	%workdir%\dcomperm -al %appid% set %appuser% permit level:la

	echo [ Restore TrustedInstaller as owner ]
	%workdir%\setacl -on "%keyname%" -ot reg -actn setowner -ownr "n:%sid_ti%;s:y" -silent
)

echo [ Finished ]
pause
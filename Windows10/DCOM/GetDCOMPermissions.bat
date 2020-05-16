@echo off

:: Author:      Cameron Kollwitz
:: Description: Gets the DCOM Permissions on the Device.

set appid={61738644-F196-11D0-9953-00C04FD919C1}
set workdir=%~dp0

echo [ Get DCOM permissions ]
%workdir%\dcomperm -al %appid% list

echo [ Finished ]
pause
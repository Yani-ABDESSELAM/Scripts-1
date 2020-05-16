@echo off

:: Author:      Cameron Kollwitz
:: Description: Reset LockScreen Wallpaper and Legal Notice on the Device.

:: Reverts back to the default wallpaper
REG DELETE "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\Personalization" /V LockScreenImage /F

:: Force Image back to Default (img100.jpg)
REG ADD "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\Personalization" /V LockScreenImage /T REG_SZ /D C:\windows\Web\Screen\img100.jpg /F

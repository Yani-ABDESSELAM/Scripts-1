@echo OFF

:: Author:      Cameron Kollwitz
:: Description: Sets Device Manager to display Hidden Devices and then launches the Device Manager.

SET devmgr_show_nonpresent_devices=1
START devmgmt.msc
PAUSE

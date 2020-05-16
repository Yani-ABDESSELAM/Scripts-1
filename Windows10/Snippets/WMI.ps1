
WMI Query

The following WMI queries can be used as inspiration when working with driveres and other OS Deployment stuff…
IMPORTANT: If you copy/paste these queries, you might need to replace the quotes, as they often change format when you copy them from a website.

Dell | Hewlett-Packard | Lenovo | Microsoft | VMWare | Operating System
Dell

Manufacturer is Dell:
SELECT * FROM Win32_ComputerSystem WHERE Manufacturer LIKE “%Dell%”

Models from Dell:
SELECT * FROM Win32_ComputerSystem WHERE Model LIKE “%Latitude E7440%”
SELECT * FROM Win32_ComputerSystem WHERE Model LIKE “%Optiplex 990%”
SELECT * FROM Win32_ComputerSystem WHERE Model LIKE “%Precision M6800%”
SELECT * FROM Win32_ComputerSystem WHERE Model LIKE “%Venue 11 Pro 7130%”
Hewlett-Packard

Manufacturer is Hewlett-Packard:
SELECT * FROM Win32_ComputerSystem WHERE Manufacturer LIKE “%Hewlett-Packard%”

Models from Hewlett-Packard:
SELECT * FROM Win32_ComputerSystem WHERE Model LIKE “%HP EliteBook 8540p%”
SELECT * FROM Win32_ComputerSystem WHERE Model LIKE “%HP EliteBook 8560w%”
SELECT * FROM Win32_ComputerSystem WHERE Model LIKE “%ElitePad 1000%”
Lenovo

Manufacturer is Lenovo:
SELECT * FROM Win32_ComputerSystem WHERE Manufacturer LIKE “%Lenovo%”

Models from Lenovo:
SELECT * FROM Win32_ComputerSystemProduct WHERE Version LIKE “%ThinkPad T420%”
SELECT * FROM Win32_ComputerSystemProduct WHERE Version LIKE “%ThinkPad W520%”
SELECT * FROM Win32_ComputerSystemProduct WHERE Version LIKE “%ThinkPad Edge E330%”
SELECT * FROM Win32_ComputerSystemProduct WHERE Version LIKE “%ThinkPad Tablet 2%”
Microsoft Hyper-V

SELECT * FROM Win32_ComputerSystem WHERE Manufacturer LIKE “%Microsoft Corporation%” AND Model LIKE “%Virtual Machine%”
VMWare

SELECT * FROM Win32_ComputerSystem WHERE Manufacturer LIKE “%VMware%” AND Model LIKE “%VMware Virtual Platform%”
Operating System (Windows)

Determine 32 or 64-bit Operating System:
SELECT * FROM Win32_ComputerSystem WHERE SystemType LIKE “%x64-based PC%”
SELECT * FROM Win32_ComputerSystem WHERE SystemType LIKE “%x86-based PC%”

Determine Operating System version:
SELECT * FROM WIN32_OperatingSystem WHERE Version LIKE “6.1%”
SELECT * FROM WIN32_OperatingSystem WHERE Version LIKE “6.3%”
Usefull Commands

wmic baseboard get product
wmic csproduct get name
wmic csproduct get vendor, version
wmic computersystem get model,name,manufacturer,systemtype

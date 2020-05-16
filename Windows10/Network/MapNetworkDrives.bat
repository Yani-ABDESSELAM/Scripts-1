@echo off

:: Author:      Cameron Kollwitz
:: Description: Maps the defined Network Locations to Network Drives as-defined.

NET USE f: /Delete
NET USE f: \\DOMAIN.TLD\SHARE$ /PERSISTENT:YES

NET USE p: /Delete
NET USE p: \\DOMAIN.TLD\PUBLIC$ /PERSISTENT:YES

NET USE x: /Delete
NET USE x: \\DOMAIN.TLD\DATA$ /PERSISTENT:YES

NET USE z: /Delete
NET USE z: \\DOMAIN.TLD\HOME$ /PERSISTENT:YES

EXIT

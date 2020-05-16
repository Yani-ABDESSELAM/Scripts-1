:: Author:      Cameron Kollwitz
:: Description: "Good Rabbit." Adds the hard-coded kill-switch to the Device to prevent infection of the Bad Rabbit Ransomware malware.

ECHO "" > C:\Windows\cscc.dat&&echo "" > C:\Windows\infpub.dat

ICACLS C:\Windows\cscc.dat /inheritance:r

ICACLS C:\Windows\infpub.dat /inheritance:r

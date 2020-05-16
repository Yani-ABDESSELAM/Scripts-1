:: Author:      Cameron Kollwitz
:: Description: Undos the "Good Rabbit" patch by removing the hard-coded kill-switch from the Device for the Bad Rabbit Ransomware malware.

ICACLS C:\Windows\cscc.dat /inheritance:e
ICACLS C:\Windows\infpub.dat /inheritance:e

:: Clear-Credential-Manager.bat
:: Icon Path: "%SystemRoot%\system32\Vault.dll"
For /F "tokens=1,2 delims= " %%G in ('cmdkey /list ^| findstr Target') do cmdkey /delete %%H

# Icon Path: "%SystemRoot%\system32\Vault.dll"
cmd.exe /c """For /F "tokens=1,2 delims= " %%G in ('cmdkey /list ^| findstr Target') do cmdkey /delete %%H"""

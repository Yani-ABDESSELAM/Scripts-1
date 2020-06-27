:: Will apply all Windows Updates found in the defined directory and its subdirectories
:: NO TRAILING SLASH!
Set Folder="C:\PATH\TO\UPDATE\LOCATION"
for %%f in (%Folder%\*.msu) do (
  wusa.exe %%f /quiet /norestart
) 
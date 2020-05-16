# Convert a file into a base64 string
# Use:    .\ConvertTo-Base64String.ps1 C:\Path\To\Image.png >> C:\Path\To\Image.png.base64

Param([String]$Path)
[Convert]::ToBase64String((Get-Content $Path -Encoding Byte))

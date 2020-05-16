# ConvertTo-PNGFromICO.ps1
# Convert an ICO file to PNG

$ICOFiles = Get-ChildItem "D:\Temp\ICO" -Filter *.ico -file -Recurse | 

ForEach-Object {
  $Source = $_.FullName
  $test = [System.IO.Path]::GetDirectoryName($source)
  $base = $_.BaseName + ".png"
  $basedir = $test + "\" + $base
  Write-Host $basedir
  Add-Type -AssemblyName system.drawing
  $imageFormat = "System.Drawing.Imaging.ImageFormat" -as [type]
  $image = [drawing.image]::FromFile($Source)

  # Create a new image
  $NewImage = [System.Drawing.Bitmap]::new($Image.Width, $Image.Height)
  $NewImage.SetResolution($Image.HorizontalResolution, $Image.VerticalResolution)

  # Add graphics based on the new image
  $Graphics = [System.Drawing.Graphics]::FromImage($NewImage)
  $Graphics.Clear([System.Drawing.Color]::White) # Set the color to white
  $Graphics.DrawImageUnscaled($image, 0, 0) # Add the contents of $image

  # Now save the $NewImage
  $NewImage.Save($basedir, $imageFormat::Png)
}

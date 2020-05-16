# Disables the "Receive Updates for Other Microsoft Products When You Update Windows" Checkbox on the Device

$ServiceManager = New-Object -ComObject "Microsoft.Update.ServiceManager"
$ServiceManager.RemoveService("7971f918-a847-4430-9279-4a52d1efe18d")

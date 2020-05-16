# Enables the "Receive Updates for Other Microsoft Products When You Update Windows" Checkbox on the Device

$ServiceManager = New-Object -ComObject "Microsoft.Update.ServiceManager"
$ServiceManager.ClientApplicationID = "Update Microsoft Products"
$NewService = $ServiceManager.AddService2("7971f918-a847-4430-9279-4a52d1efe18d",7,"")

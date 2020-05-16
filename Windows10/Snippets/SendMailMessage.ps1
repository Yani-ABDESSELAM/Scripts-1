# SendMailMessage Function

# Dynamic Variables (Safe to edit)
$From = ""
$To = ""
# NOTE: You must have permissions to send on the mail server!
$MailServer = ""

Function SendMailMessage {
  Param(
    [String]$Subject,
    [String]$Body
  )
  Send-MailMessage -SmtpServer $MailServer -From $From -To $To -Subject $Subject -Body $Body
}
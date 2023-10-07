$outlook = new-object -comobject outlook.application
$email = $outlook.CreateItem(0)
$email.To = "maninder.o.singh@accenture.com"
$email.Subject = "Ignore - Test Email by Powershell Script"
$email.Body = "Body"
$email.Send()
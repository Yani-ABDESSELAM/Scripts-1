# EXAMPLE: Get-EpochDate 1520000000
Function Get-EpochDate ($epochDate) { 
  [timezone]::CurrentTimeZone.ToLocalTime(([datetime]'1/1/1970').AddSeconds($epochDate))
}

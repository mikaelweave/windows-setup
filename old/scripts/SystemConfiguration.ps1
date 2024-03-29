# Taken from https://github.com/microsoft/windows-dev-box-setup-scripts/blob/9270cd2d048349589f3e12f9349bfa7f0189ddb6/scripts/SystemConfiguration.ps1

#--- Enable developer mode on the system ---
Set-ItemProperty -Path HKLM:\Software\Microsoft\Windows\CurrentVersion\AppModelUnlock -Name AllowDevelopmentWithoutDevLicense -Value 1

# Make windows clock play nice with Linux
Set-ItemProperty -Path HKLM:\System\CurrentControlSet\Control\TimeZoneInformation -Name RealTimeIsUniversal -Value 1 -PropertyType DWord
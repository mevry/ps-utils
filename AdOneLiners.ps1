#Get enabled AD Computers, sorted by LastLogonDate
Get-AdComputer -Filter * -Properties OperatingSystem,OperatingSystemVersion,LastLogonDate,Enabled | ? Enabled -eq $true | sort-object -property LastLogonDate -Descending | Select Name,OperatingSystem,OperatingSystemVersion,LastLogonDate

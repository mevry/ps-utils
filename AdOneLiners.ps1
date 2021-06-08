#Get enabled AD Computers, sorted by LastLogonDate
Get-AdComputer -Filter * -Properties OperatingSystem,OperatingSystemVersion,LastLogonDate,Enabled | ? Enabled -eq $true | sort-object -property LastLogonDate -Descending | Select Name,OperatingSystem,OperatingSystemVersion,LastLogonDate

#Get AD Replication subnets
Get-ADReplicationSubnet -Filter * | select Name,@{n="Site";e={$_.Site.Split(",") | select -first 1 | % {$_.Substring(3)}}}

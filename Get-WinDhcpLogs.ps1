[cmdletbinding()]
param(
    [Parameter(Mandatory)]
    $Path,
    $FilterOn = $true,
    $EventFilter = "11|30|32|24|25"
)
$headers = "ID","Date","Time","Description","IPAddress","Host","MAC","User","TransactionID","QResult","ProbationTime","CorellationID","Dhcid","VendorClassHex","VendorClassAscii","UserClassHex","UserClassAscii","RelayAgentInformation","DnsRegError"
$logData = @()
foreach ($file in (gci -Path $Path | ? {$_.Name -match "^DhcpSrvLog-"} | Select -expand FullName)){
    $csv = Get-Content  $file
    #strip out first 33 lines
    $csv = $csv[33..($csv.Length-1)]
    #new Win DHCP server logs have extra lines; easier to filter that line 
    $logData += $csv | ? {$_ -notmatch "^ID"}
}


$logEntries = $logData | ConvertFrom-Csv -Header $headers | Sort-Object Date,Time -Descending
#apply filter or not

if ($FilterOn){
    $logEntries | ? {$_.id -notmatch $EventFilter}
}
else{
    $logEntries
}
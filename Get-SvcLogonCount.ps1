[cmdletbinding()]
param(
    [Parameter(Mandatory,ParameterSetName="BySearchOU")]
    [Parameter(Mandatory,ParameterSetName="BySAMName")]
    [string[]]$DomainControllers,
    [Parameter(Mandatory,ParameterSetName="BySearchOU")]
    [string]$SearchOU,
    [Parameter(Mandatory,ParameterSetName="BySAMName")]
    [string[]]$SAMName
)
#Logon event
$eventLogId = @(4624,4625)

#Get SAM account names in search OU.
if($SearchOU){
    $serviceAccounts = Get-ADUser -Filter * -SearchBase $searchOu | Select-Object -ExpandProperty SamAccountName
}
if($SAMName){
    $serviceAccounts = $SAMName
}

#Get event logs of logon events with found SAM account names. Store account name and IP addr
$serviceAccountLogons = Get-EventLog -ComputerName $DomainControllers -LogName 'Security' -InstanceId $eventLogId  | Where-Object {$serviceAccounts -contains $_.ReplacementStrings[5]} | Select-Object @{n="Account";e={$_.ReplacementStrings[5]}},@{n="IP";e={$_.ReplacementStrings[18]}} 

#Group by account name, then IP
$serviceAccountLogons | Group-Object Account,IP

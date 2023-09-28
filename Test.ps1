Import-Module .\ArcherAPI.ps1
Import-Module .\ArcherContent.ps1
Import-Module .\ArcherSearch.ps1

Clear-Host

$archerAPI = [ArcherAPI]::new('http://192.168.44.10/Archer')
$loginResponse = $archerAPI.Login( 'webapi', 'Archer@123', 'oda', '')
if ($loginResponse.IsSuccessful -eq $False) {
    throw 'Authentication Unsuccessful' + $loginResponse.Exception
}
$sessionToken = $archerAPI.sessionToken

#$archerContent = [ArcherContent]::new('http://192.168.44.10/Archer',$sessionToken)
<#Clear-Host
#get record
$record = $archerContent.Record_Get(205555).Value
$record | ConvertTo-Json #>

<#Clear-Host
#create record - create request json first, then pass request json to Record_Create method
$rJSON = [RequestJSON]::new($True)
$rJSON.AddFieldData( 2974 , 1 , 'API Test Company' )
$rJSON.AddFieldData( 2973 , 1 , 'API Test Company' )
$rJSON.AddFieldData( 2972 , 1 , 'API Test Company' )
$reqJSON = $rJSON.Create(34,0)
Write-Host $reqJSON
$recordID  = $archerContent.Record_Create($reqJSON).Value #>

$aO = [ArcherSearch]::new('http://192.168.44.10/Archer', $sessionToken)
$ko = $aO.SearchRecordsByReport(13794, 1).Value
Clear-Host
Write-Host $ko
Write-Host 'END"'


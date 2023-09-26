Import-Module .\ArcherAPI.ps1
Import-Module .\ArcherContent.ps1

Clear-Host

$archerAPI = [ArcherAPI]::new('http://192.168.44.10/Archer')
$loginResponse = $archerAPI.Login( 'webapi', 'Archer@123', 'oda','')


$reqJSON = [RequestJSON]::new
$tVar1 = $reqJSON.AddFieldData()
Write-Host $tVar1


<#

if($loginResponse.IsSuccessful -eq $True)
{
    $sessionToken = $archerAPI.sessionToken
    Write-Output 'Authentication Successful' $sessionToken ''
}
else
{
    Write-Output 'Authentication Unsuccessful' $loginResponse.Exception
}

$logoutResponse = $archerAPI.Logout();

if($logoutResponse.IsSuccessful -eq $True)
{
    Write-Output $logoutResponse.Value
}
else
{
    Write-Output 'Unable to KO' $logoutResponse.Value $logoutResponse.Exception $logoutResponse.IsSuccessful $logoutResponse.Response
}
#>
Import-Module .\ArcherAPI.ps1

clear

$archerAuth = [ArcherAPI]::new('http://192.168.44.10/Archer')
$loginResponse = $archerAuth.Login( 'webapi', 'Archer@123', 'oda','')

if($loginResponse.IsSuccessful -eq $True)
{
    $sessionToken = $archerAPI.sessionToken
    Write-Output 'Authentication Successful' $sessionToken ''
}
elseif ($loginResponse.IsSuccessful -eq $False)
{
    Write-Output 'Authentication Unsuccessful' $loginResponse.Exception
}
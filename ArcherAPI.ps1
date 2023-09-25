class AResponse
{
    [string]$Value
    [bool]$IsSuccessful
    [object]$Exception
    [object]$Response

    AResponse($Value,$IsSuccessful,$Exception,$Response)
    {
        $this.Value = $Value
        $this.IsSuccessful = $IsSuccessful
        $this.Exception = $Exception
        $this.Response = $Response
    }
}
class ArcherAPI {
    [string] $baseURL
    [object] $response
    [string] $sessionToken

    ArcherAPI([string] $baseURL)
    {
        $this.baseURL = $baseURL
    }

    [AResponse] Login([string]$userName,[string]$password,[string]$instanceName,$userDomain )
    {
        try
        {
            $requestURL = $this.baseURL+'/platformapi/core/security/login'
            $headers = @{"Content-Type" ="application/json"}

            $body = @{
                "InstanceName" = $instanceName
                "Username" = $userName
                "UserDomain" = $userDomain
                "Password" = $password
                } | ConvertTo-Json
            $this.response = Invoke-RestMethod $requestURL -Method 'POST' -Headers $headers -Body $body
            if($this.response.IsSuccessful -eq $False)
            {
                throw $this.response.ValidationMessages.MessageKey
            }
            $this.sessionToken = $this.response.RequestedObject.SessionToken
            $okResult = [AResponse]::new($this.sessionToken,$this.response.IsSuccessful,'',$this.response)
            return $okResult
        }
        catch
        {
            $failResult = [AResponse]::new($_.Exception.Message,$this.response.IsSuccessful,$_.Exception,$this.response)
            return $failResult
        }
    }

    [AResponse] Logout()
    {
        try
        {
            $requestURL = $this.baseURL+'/platformapi/core/security/logout'
            $headers = @{
                "Content-Type" ="application/json"
                "Authorization" = "Archer session-id=`""+$this.sessionToken+"`""
            }
            $body = @{
                "Value" = $this.sessionToken
                } | ConvertTo-Json
            $this.response = Invoke-RestMethod $requestURL -Method 'POST' -Headers $headers -Body $body
            if($this.response.IsSuccessful -eq $False)
            {
                throw $this.response.ValidationMessages.MessageKey
            }
            $okResult = [AResponse]::new('KO',$this.response.IsSuccessful,'',$this.response)
            return $okResult
        }
        catch
        {
            $failResult = [AResponse]::new($_.Exception.Message,$this.response.IsSuccessful,$_.Exception,$this.response)
            return $failResult
        }
    }
}


Clear-Host

$archerAPI = [ArcherAPI]::new('http://192.168.44.10/Archer')
$loginResponse = $archerAPI.Login( 'webapi', 'Archer@123', 'oda','')

if ($loginResponse.IsSuccessful -eq $False)
{
    throw 'Authentication Unsuccessful' -$loginResponse.Exception
}
$sessionToken = $archerAPI.sessionToken
    Write-Output 'Authentication Successful' $sessionToken ''

$logoutResponse = $archerAPI.Logout();
if ($logoutResponse.IsSuccessful -eq $False)
{
    throw 'Unable to KO' -$logoutResponse.Value -$logoutResponse.Exception -$logoutResponse.IsSuccessful -$logoutResponse.Response
}
Write-Output 'KO'

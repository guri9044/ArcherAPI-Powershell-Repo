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
            #$headers = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
            $headers = @{
                "Content-Type" ="application/json"
                }

            $body = @{
                "InstanceName" = $instanceName
                "Username" = $userName
                "UserDomain" = $userDomain
                "Password" = $password
            } | ConvertTo-Json

            #$body = $body | ConvertTo-Json
            $this.response = Invoke-RestMethod $requestURL -Method 'POST' -Headers $headers -Body $body
            if($this.response.IsSuccessful -eq $True)
            {
                $this.sessionToken = $this.response.RequestedObject.SessionToken
                $okResult = [AResponse]::new($this.sessionToken,$this.response.IsSuccessful,'',$this.response)
                return $okResult
            }
            else
            {
                throw $this.response.ValidationMessages.MessageKey
            }
        }
        catch
        {
            $failResult = [AResponse]::new($_.Exception.Message,$this.response.IsSuccessful,$_.Exception,$this.response)
            return $failResult
        }
    }

    [AResponse] Logout([string]$sessionToken)
    {
        try
        {
            $requestURL = $this.baseURL+'/platformapi/core/security/logout'
            $headers = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
            $headers.Add("Content-Type", "application/json")

            $body = @{
                "Value" = $sessionToken
            }

            $body = $body | ConvertTo-Json
            $this.response = Invoke-RestMethod $requestURL -Method 'POST' -Headers $headers -Body $body
            if($this.response.IsSuccessful -eq $True)
            {
                $okResult = [AResponse]::new('KO',$this.response.IsSuccessful,'',$this.response)
                return $okResult
            }
            else
            {
                throw $this.response.ValidationMessages.MessageKey
            }
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

if($loginResponse.IsSuccessful -eq $True)
{
    $sessionToken = $archerAPI.sessionToken
    Write-Output 'Authentication Successful' $sessionToken ''
}
elseif ($loginResponse.IsSuccessful -eq $False)
{
    Write-Output 'Authentication Unsuccessful' $loginResponse.Exception
}

$logoutResponse = $archerAPI.Logout($sessionToken);

if($logoutResponse.IsSuccessful -eq $True)
{
    Write-Output 'KO'
}
elseif ($logoutResponse.IsSuccessful -eq $False)
{
    Write-Output 'Unable to KO' $logoutResponse.Value $logoutResponse.Exception $logoutResponse.IsSuccessful $logoutResponse.Response
}
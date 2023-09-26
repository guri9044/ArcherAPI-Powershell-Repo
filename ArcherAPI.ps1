#Import-Module .\ArcherContent.ps1
class AResponse {
    [string]$Value
    [bool]$IsSuccessful
    [object]$Exception
    [object]$Response

    AResponse($Value, $IsSuccessful, $Exception, $Response) {
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

    ArcherAPI([string] $baseURL) {
        $this.baseURL = $baseURL
    }

    [AResponse] Login([string]$userName, [string]$password, [string]$instanceName, $userDomain ) {
        try {
            $requestURL = $this.baseURL + '/platformapi/core/security/login'
            $headers = @{"Content-Type" = "application/json" }

            $body = @{
                "InstanceName" = $instanceName
                "Username"     = $userName
                "UserDomain"   = $userDomain
                "Password"     = $password
            } | ConvertTo-Json
            $this.response = Invoke-RestMethod $requestURL -Method 'POST' -Headers $headers -Body $body
            if ($this.response.IsSuccessful -eq $False) {
                throw $this.response.ValidationMessages.MessageKey
            }
            $this.sessionToken = $this.response.RequestedObject.SessionToken
            $okResult = [AResponse]::new($this.sessionToken, $this.response.IsSuccessful, '', $this.response)
            return $okResult
        }
        catch {
            $failResult = [AResponse]::new($_.Exception.Message, $this.response.IsSuccessful, $_.Exception, $this.response)
            return $failResult
        }
    }

    [AResponse] Login2([string]$userName, [string]$password, [string]$instanceName, $userDomain ) {
        try {
            $okResult = [AResponse]::new($userName, $password, '', $instanceName)
            return $okResult
        }
        catch {
            $okResult = [AResponse]::new($userName, $password, '', $instanceName)
            return $okResult
        }
    }

    [AResponse] Logout() {
        try {
            $requestURL = $this.baseURL + '/platformapi/core/security/logout'
            $headers = @{
                "Content-Type"  = "application/json"
                "Authorization" = "Archer session-id=`"" + $this.sessionToken + "`""
            }
            $body = @{
                "Value" = $this.sessionToken
            } | ConvertTo-Json
            $this.response = Invoke-RestMethod $requestURL -Method 'POST' -Headers $headers -Body $body
            if ($this.response.IsSuccessful -eq $False) {
                throw $this.response.ValidationMessages.MessageKey
            }
            $okResult = [AResponse]::new('KO', $this.response.IsSuccessful, '', $this.response)
            return $okResult
        }
        catch {
            $failResult = [AResponse]::new($_.Exception.Message, $this.response.IsSuccessful, $_.Exception, $this.response)
            return $failResult
        }
    }
}
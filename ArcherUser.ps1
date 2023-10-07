class ArcherUser {
    $response = $null
    $sessionToken = $null
    $baseURL = $null
    ArcherUser([string] $baseURL , [string] $sessionToken) {
        $this.sessionToken = $sessionToken
        $this.baseURL = $baseURL
    }

    [AResponse] Users_Get() {
        try {
            $requestURL = $this.baseURL + '/platformapi/core/system/user'
            $headers = @{
                "Content-Type"            = "application/json"
                "Authorization"           = "Archer session-id=`"" + $this.sessionToken + "`""
                "__ArcherSessionCookie__" = $this.sessionToken
                "X-Http-Method-Override"  = "GET"
            }

            $this.response = Invoke-RestMethod $requestURL -Method 'POST' -Headers $headers -Body $null 
            if ($this.response.IsSuccessful -eq $False) {
                throw $this.response.ValidationMessages.MessageKey
            }
            $record = $this.response.RequestedObject
            $okResult = [AResponse]::new($record, $this.response.IsSuccessful, '', $this.response)
            return $okResult
        }
        catch {
            $failResult = [AResponse]::new($_.Exception.Message, $this.response.IsSuccessful, $_.Exception, $this.response)
            return $failResult
        }
    }

    [AResponse] User_Get([int] $userId) {
        try {
            $requestURL = $this.baseURL + '/platformapi/core/system/user/' + $userId
            $headers = @{
                "Content-Type"            = "application/json"
                "Authorization"           = "Archer session-id=`"" + $this.sessionToken + "`""
                "__ArcherSessionCookie__" = $this.sessionToken
                "X-Http-Method-Override"  = "GET"
            }

            $this.response = Invoke-RestMethod $requestURL -Method 'POST' -Headers $headers -Body $null 
            if ($this.response.IsSuccessful -eq $False) {
                throw $this.response.ValidationMessages.MessageKey
            }
            $record = $this.response.RequestedObject
            $okResult = [AResponse]::new($record, $this.response.IsSuccessful, '', $this.response)
            return $okResult
        }
        catch {
            $failResult = [AResponse]::new($_.Exception.Message, $this.response.IsSuccessful, $_.Exception, $this.response)
            return $failResult
        }
    }
   
    [AResponse] User_Update([int] $userId) {
        try {
            $requestURL = $this.baseURL + '/platformapi/core/system/levellayout/level/' + $userId
            $headers = @{
                "Content-Type"            = "application/json"
                "Authorization"           = "Archer session-id=`"" + $this.sessionToken + "`""
                "__ArcherSessionCookie__" = $this.sessionToken
                "X-Http-Method-Override"  = "GET"
            }

            $this.response = Invoke-RestMethod $requestURL -Method 'POST' -Headers $headers -Body $null 
            if ($this.response.IsSuccessful -eq $False) {
                throw $this.response.ValidationMessages.MessageKey
            }
            $record = $this.response.RequestedObject
            $okResult = [AResponse]::new($record, $this.response.IsSuccessful, '', $this.response)
            return $okResult
        }
        catch {
            $failResult = [AResponse]::new($_.Exception.Message, $this.response.IsSuccessful, $_.Exception, $this.response)
            return $failResult
        }
    }
}

class AResponse {
    [object]$Value
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
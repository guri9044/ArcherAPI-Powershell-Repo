﻿class ArcherAPI {
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

    [void] LogInfo ([string] $logMessage) {
        if (-NOT(Test-Path -Path $this.logFilePath -PathType Container)) {
            New-Item -Path $this.logFilePath -ItemType Directory
            Write-Host 'Log folder created'
        }        
        $formattedTimestamp = Get-Date -Format "yyyy.MM.dd.HH.mm.ss"
        $this.fullFileName = $this.logFilePath + $this.logFileName + $formattedTimestamp + '.txt'
        Add-Content $this.fullFileName -Value '[INFO] ' + $logMessage
    }

    [void] LogError ([string] $logMessage) {
        if (-NOT(Test-Path -Path $this.logFilePath -PathType Container)) {
            New-Item -Path $this.logFilePath -ItemType Directory
            Write-Host 'Log folder created'
        } 
        $formattedTimestamp = Get-Date -Format "yyyy.MM.dd.HH.mm.ss"
        $this.fullFileName = $this.logFilePath + $this.logFileName + $formattedTimestamp + '.txt'
        Add-Content $this.fullFileName -Value '[ERROR] ' + $logMessage
    }
}
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
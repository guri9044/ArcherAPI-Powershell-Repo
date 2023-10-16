
$Global:SourceEnv = [Environment]::new()
$Global:TargetEnv = [Environment]::new()
class ArcherAuthentication {
    [string] $baseURL
    [object] $response
    [string] $sessionToken

    ArcherAuthentication([string] $baseURL) {
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
}
class ArcherUser {
    $response = $null
    $sessionToken = $null
    $baseURL = $null
    ArcherUser([string] $baseURL , [string] $sessionToken) {
        $this.sessionToken = $sessionToken
        $this.baseURL = $baseURL
    }

    [AResponse] User_Get() {
        try {
            $requestURL = $this.baseURL + '/platformapi/core/system/user'
            $headers = @{
                "Content-Type"            = "application/json"
                "Authorization"           = "Archer session-id=`"" + $this.sessionToken + "`""
                "__ArcherSessionCookie__" = $this.sessionToken
                "X-Http-Method-Override"  = "GET"
            }

            $this.response = Invoke-RestMethod $requestURL -Method 'POST' -Headers $headers -Body $null 
            if ($this.response[0].IsSuccessful -eq $False) {
                throw $this.response.ValidationMessages.MessageKey
            }
            $value = $this.response | Select-Object -ExpandProperty 'RequestedObject'
            $okResult = [AResponse]::new($value, $this.response.IsSuccessful, '', $this.response)
            return $okResult
        }
        catch {
            $failResult = [AResponse]::new($_.Exception.Message, $this.response.IsSuccessful, $_.Exception, $this.response)
            return $failResult
        }
    }

    [AResponse] User_Get([int] $userId) {
        try {
            $requestURL = $this.baseURL + "/platformapi/core/system/user/$userId"
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
            $value = $this.response.RequestedObject
            $okResult = [AResponse]::new($value, $this.response.IsSuccessful, '', $this.response)
            return $okResult
        }
        catch {
            $failResult = [AResponse]::new($_.Exception.Message, $this.response.IsSuccessful, $_.Exception, $this.response)
            return $failResult
        }
    }

    
    [AResponse] User_Update([string] $body) {
        try {
            $requestURL = $this.baseURL + '/platformapi/core/system/user'
            $headers = @{
                "Content-Type"            = "application/json"
                "Authorization"           = "Archer session-id=`"" + $this.sessionToken + "`""
                "__ArcherSessionCookie__" = $this.sessionToken
                "X-Http-Method-Override"  = "PUT"
            }

            $this.response = Invoke-RestMethod $requestURL -Method 'POST' -Headers $headers -Body $body 
            if ($this.response.IsSuccessful -eq $False) {
                throw $this.response.ValidationMessages.MessageKey
            }
            $value = $this.response.RequestedObject.Id
            $okResult = [AResponse]::new($value, $this.response.IsSuccessful, '', $this.response)
            return $okResult
        }
        catch {
            $failResult = [AResponse]::new($_.Exception.Message, $this.response.IsSuccessful, $_.Exception, $this.response)
            return $failResult
        }
    }
}
class ArcherRole {
    $response = $null
    $sessionToken = $null
    $baseURL = $null
    ArcherRole([string] $baseURL , [string] $sessionToken) {
        $this.sessionToken = $sessionToken
        $this.baseURL = $baseURL
    }

    [AResponse] Role_Get() {
        try {
            $requestURL = $this.baseURL + '/platformapi/core/system/role'
            $headers = @{
                "Content-Type"            = "application/json"
                "Authorization"           = "Archer session-id=`"" + $this.sessionToken + "`""
                "__ArcherSessionCookie__" = $this.sessionToken
                "X-Http-Method-Override"  = "GET"
            }

            $this.response = Invoke-RestMethod $requestURL -Method 'POST' -Headers $headers -Body $null 
            if ($this.response[0].IsSuccessful -eq $False) {
                throw $this.response.ValidationMessages.MessageKey
            }
            $value = $this.response | Select-Object -ExpandProperty 'RequestedObject'
            $okResult = [AResponse]::new($value, $this.response.IsSuccessful, '', $this.response)
            return $okResult
        }
        catch {
            $failResult = [AResponse]::new($_.Exception.Message, $this.response.IsSuccessful, $_.Exception, $this.response)
            return $failResult
        }
    }

    [AResponse] Role_Get([int] $Id) {
        try {
            $requestURL = $this.baseURL + "/platformapi/core/system/user/$Id"
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
            $value = $this.response.RequestedObject
            $okResult = [AResponse]::new($value, $this.response.IsSuccessful, '', $this.response)
            return $okResult
        }
        catch {
            $failResult = [AResponse]::new($_.Exception.Message, $this.response.IsSuccessful, $_.Exception, $this.response)
            return $failResult
        }
    }

    
    [AResponse] Role_Update([string] $body) {
        try {
            $requestURL = $this.baseURL + '/platformapi/core/system/user'
            $headers = @{
                "Content-Type"            = "application/json"
                "Authorization"           = "Archer session-id=`"" + $this.sessionToken + "`""
                "__ArcherSessionCookie__" = $this.sessionToken
                "X-Http-Method-Override"  = "PUT"
            }

            $this.response = Invoke-RestMethod $requestURL -Method 'POST' -Headers $headers -Body $body 
            if ($this.response.IsSuccessful -eq $False) {
                throw $this.response.ValidationMessages.MessageKey
            }
            $value = $this.response.RequestedObject.Id
            $okResult = [AResponse]::new($value, $this.response.IsSuccessful, '', $this.response)
            return $okResult
        }
        catch {
            $failResult = [AResponse]::new($_.Exception.Message, $this.response.IsSuccessful, $_.Exception, $this.response)
            return $failResult
        }
    }
}
class ArcherGroup {
    $response = $null
    $sessionToken = $null
    $baseURL = $null
    ArcherGroup([string] $baseURL , [string] $sessionToken) {
        $this.sessionToken = $sessionToken
        $this.baseURL = $baseURL
    }

    [AResponse] Group_Get() {
        try {
            $requestURL = $this.baseURL + '/platformapi/core/system/group'
            $headers = @{
                "Content-Type"            = "application/json"
                "Authorization"           = "Archer session-id=`"" + $this.sessionToken + "`""
                "__ArcherSessionCookie__" = $this.sessionToken
                "X-Http-Method-Override"  = "GET"
            }

            $this.response = Invoke-RestMethod $requestURL -Method 'POST' -Headers $headers -Body $null 
            if ($this.response[0].IsSuccessful -eq $False) {
                throw $this.response.ValidationMessages.MessageKey
            }
            $value = $this.response | Select-Object -ExpandProperty 'RequestedObject'
            $okResult = [AResponse]::new($value, $this.response.IsSuccessful, '', $this.response)
            return $okResult
        }
        catch {
            $failResult = [AResponse]::new($_.Exception.Message, $this.response.IsSuccessful, $_.Exception, $this.response)
            return $failResult
        }
    }

    [AResponse] Group_Get([int] $Id) {
        try {
            $requestURL = $this.baseURL + "/platformapi/core/system/group/$Id"
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
            $value = $this.response.RequestedObject
            $okResult = [AResponse]::new($value, $this.response.IsSuccessful, '', $this.response)
            return $okResult
        }
        catch {
            $failResult = [AResponse]::new($_.Exception.Message, $this.response.IsSuccessful, $_.Exception, $this.response)
            return $failResult
        }
    }

    
    [AResponse] Group_Update([string] $body) {
        try {
            $requestURL = $this.baseURL + '/platformapi/core/system/user'
            $headers = @{
                "Content-Type"            = "application/json"
                "Authorization"           = "Archer session-id=`"" + $this.sessionToken + "`""
                "__ArcherSessionCookie__" = $this.sessionToken
                "X-Http-Method-Override"  = "PUT"
            }

            $this.response = Invoke-RestMethod $requestURL -Method 'POST' -Headers $headers -Body $body 
            if ($this.response.IsSuccessful -eq $False) {
                throw $this.response.ValidationMessages.MessageKey
            }
            $value = $this.response.RequestedObject.Id
            $okResult = [AResponse]::new($value, $this.response.IsSuccessful, '', $this.response)
            return $okResult
        }
        catch {
            $failResult = [AResponse]::new($_.Exception.Message, $this.response.IsSuccessful, $_.Exception, $this.response)
            return $failResult
        }
    }
}
class ArcherLevel {
    $response = $null
    $sessionToken = $null
    $baseURL = $null
    ArcherLevel([string] $baseURL , [string] $sessionToken) {
        $this.sessionToken = $sessionToken
        $this.baseURL = $baseURL
    }

    [AResponse] Level_Get() {
        try {
            $requestURL = $this.baseURL + '/platformapi/core/system/level'
            $headers = @{
                "Content-Type"            = "application/json"
                "Authorization"           = "Archer session-id=`"" + $this.sessionToken + "`""
                "__ArcherSessionCookie__" = $this.sessionToken
                "X-Http-Method-Override"  = "GET"
            }

            $this.response = Invoke-RestMethod $requestURL -Method 'POST' -Headers $headers -Body $null 
            if ($this.response[0].IsSuccessful -eq $False) {
                throw $this.response.ValidationMessages.MessageKey
            }
            $data = $this.response | Select-Object -ExpandProperty 'RequestedObject'
            $okResult = [AResponse]::new($data, $this.response[0].IsSuccessful, '', $this.response)
            return $okResult
        }
        catch {
            $failResult = [AResponse]::new($_.Exception.Message, $this.response.IsSuccessful, $_.Exception, $this.response)
            return $failResult
        }
    }

    [AResponse] Level_Get([int] $id, [string] $type) {
        try {
            if ($type -eq 'level') {
                $requestURL = $this.baseURL + '/platformapi/core/system/level/' + $id
            }
            elseif ($type -eq 'module') {
                $requestURL = $this.baseURL + '/platformapi/core/system/level/module/' + $id
            }
            else {
                throw "Invalid type parameter passed. Allowed values are 'level' and 'module'"
            }
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
   
    [AResponse] LevelLayout_Get([int] $levelId) {
        try {
            $requestURL = $this.baseURL + '/platformapi/core/system/levellayout/level/' + $levelId
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
class ArcherContent {
    $response = $null
    $sessionToken = $null
    $baseURL = $null
    ArcherContent([string] $baseURL , [string] $sessionToken) {
        $this.sessionToken = $sessionToken
        $this.baseURL = $baseURL
    }
    [AResponse] Record_Create([string]$requestJSON) {
        try {
            $requestURL = $this.baseURL + '/platformapi/core/content'
            $headers = @{
                "Content-Type"            = "application/json"
                "Authorization"           = "Archer session-id=`"" + $this.sessionToken + "`""
                "__ArcherSessionCookie__" = $this.sessionToken
            }

            $this.response = Invoke-RestMethod $requestURL -Method 'POST' -Headers $headers -Body $requestJSON
            if ($this.response.IsSuccessful -eq $False) {
                throw $this.response.ValidationMessages.MessageKey
            }
            $recordID = $this.response.RequestedObject.Id
            $okResult = [AResponse]::new($recordID, $this.response.IsSuccessful, '', $this.response)
            return $okResult
        }
        catch {
            $failResult = [AResponse]::new($_.Exception.Message, $this.response.IsSuccessful, $_.Exception, $this.response)
            return $failResult
        }
    }

    [AResponse] Record_Get([int]$ContentID) {
        try {
            $requestURL = $this.baseURL + '/platformapi/core/content/contentid?id=' + $ContentID
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
class ArcherSearch {
    $response = $null
    $sessionToken = $null
    $baseURL = $null
    ArcherSearch([string] $baseURL , [string] $sessionToken) {
        $this.sessionToken = $sessionToken
        $this.baseURL = $baseURL
    }
    
    [AResponse] SearchRecordsByReport([object] $reportIDorGUID, [int] $pageNumber) {
        try {
            $requestURL = $this.baseURL + '/ws/search.asmx'
            $headers = @{
                "Authorization"           = "Archer session-id=`"" + $this.sessionToken + "`""
                "__ArcherSessionCookie__" = $this.sessionToken
                "Accept"                  = "text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7"
                "Content-Type"            = "text/xml"
            }
            $body = "<?xml version=`"1.0`" encoding=`"utf-8`"?><soap12:Envelope xmlns:xsi=`"http://www.w3.org/2001/XMLSchema-instance`" xmlns:xsd=`"http://www.w3.org/2001/XMLSchema`" xmlns:soap12=`"http://www.w3.org/2003/05/soap-envelope`"><soap12:Body><SearchRecordsByReport xmlns=`"http://archer-tech.com/webservices/`"><sessionToken>" + $this.sessionToken + "</sessionToken><reportIdOrGuid>" + $reportIDorGUID + "</reportIdOrGuid><pageNumber>" + $pageNumber + "</pageNumber></SearchRecordsByReport></soap12:Body></soap12:Envelope>"
            $this.response = Invoke-RestMethod $requestURL -Method 'POST' -Headers $headers -Body $body
            $xmlResponse = [XML]$this.response
            $responseResult = $xmlResponse.Envelope.Body.SearchRecordsByReportResponse.SearchRecordsByReportResult
            $okResult = [AResponse]::new($responseResult, $True, '', $this.response)
            return $okResult
        }
        catch {
            $failResult = [AResponse]::new($_.Exception.Message, $this.response.IsSuccessful, $_.Exception, $this.response)
            return $failResult
        }
    }

    [AResponse] SearchRecordsByReportJSON([object] $reportIDorGUID) {
        try {
            $response1 = $this.SearchRecordsByReport($reportIDorGUID, 1)
            if ($response1.IsSuccessful -eq $False) {
                throw $response1.Exception
            }
            $aL = [ArcherLevel]::new($this.baseURL, $this.sessionToken)
            $allLevels = $aL.Level_Get()
            $var1 = PrivateExtractRecordsfromXML($response1.Value, $allLevels)
            $okResult = [AResponse]::new($var1, $True, '', $this.response)
            $okResult = [AResponse]::new($response1, $True, '', $this.response)
            return $okResult
        }
        catch {
            $failResult = [AResponse]::new($_.Exception.Message, $this.response.IsSuccessful, $_.Exception, $this.response)
            return $failResult
        }
    }
}
class ArcherNotification {
    $response = $null
    $sessionToken = $null
    $baseURL = $null
    ArcherNotification([string] $baseURL , [string] $sessionToken) {
        $this.sessionToken = $sessionToken
        $this.baseURL = $baseURL
    }

    [AResponse] Notification_Get() {
        try {
            $requestURL = $this.baseURL + '/api/V2/internal/Notifications'
            $headers = @{
                "Content-Type"            = "application/json"
                "Authorization"           = "Archer session-id=`"" + $this.sessionToken + "`""
                "__ArcherSessionCookie__" = $this.sessionToken
                "X-Http-Method-Override"  = "GET"
            }

            $this.response = Invoke-WebRequest $requestURL -Method 'POST' -Headers $headers -Body $null 
            if ($this.response.StatusCode -ne 200) {
                throw $this.response.ValidationMessages.MessageKey
            }
            $value = $this.response.Content
            $okResult = [AResponse]::new($value, $true, '', $this.response)
            return $okResult
        }
        catch {
            $failResult = [AResponse]::new($_.Exception.Message, $this.response.IsSuccessful, $_.Exception, $this.response)
            return $failResult
        }
    }

    [AResponse] Notification_Get([int] $Id) {
        try {
            $requestURL = $this.baseURL + "/api/V2/internal/Notifications($Id)"
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
            $value = $this.response.RequestedObject
            $okResult = [AResponse]::new($value, $this.response.IsSuccessful, '', $this.response)
            return $okResult
        }
        catch {
            $failResult = [AResponse]::new($_.Exception.Message, $this.response.IsSuccessful, $_.Exception, $this.response)
            return $failResult
        }
    }

    
    [AResponse] Notification_Update([string] $body) {
        try {
            $requestURL = $this.baseURL + '/api/V2/internal/Notifications'
            $headers = @{
                "Content-Type"            = "application/json"
                "Authorization"           = "Archer session-id=`"" + $this.sessionToken + "`""
                "__ArcherSessionCookie__" = $this.sessionToken
                "X-Http-Method-Override"  = "PUT"
            }

            $this.response = Invoke-RestMethod $requestURL -Method 'POST' -Headers $headers -Body $body 
            if ($this.response.IsSuccessful -eq $False) {
                throw $this.response.ValidationMessages.MessageKey
            }
            $value = $this.response.RequestedObject.Id
            $okResult = [AResponse]::new($value, $this.response.IsSuccessful, '', $this.response)
            return $okResult
        }
        catch {
            $failResult = [AResponse]::new($_.Exception.Message, $this.response.IsSuccessful, $_.Exception, $this.response)
            return $failResult
        }
    }
}
<#********** Archer Supporting Classes **********#>
class ContentRequestJSON {
    <# Helps Create JSON for creating/updating records via Archer Content API #>
    [string] $requestJSON = $null
    [bool] $FieldsDataAdded = $false
    [System.Collections.Generic.List[string]] $FieldContentRequestJSON = @()

    RequestJSON([bool] $FieldsDataAdded) {
        $this.FieldsDataAdded = $FieldsDataAdded
    }

    [void] AddFieldData([int] $Fieldid, [int] $FieldType, [string] $FieldData) {
        try {
            # $this.FieldsDataAdded = $True
            if ($FieldType -eq 1 -or $FieldType -eq 2 -or $FieldType -eq 3) {
                $var = '"' + $Fieldid + '": {"Type": ' + $FieldType + ',"Value": "' + $FieldData + '","FieldId": ' + $Fieldid + '}'
                $this.FieldContentRequestJSON.Add($var)
            }
            elseif ($FieldType -eq 9) {
                $RecordIdsList = $FieldData.Split(',')
                [System.Collections.Generic.List[string]] $tempVar = @()
                $tempVar = $RecordIdsList | ForEach-Object { '{ "ContentId": ' + $_ + '}' }
                $RecordString = $tempVar -join ','
                $this.FieldContentRequestJSON.Add('"' + $Fieldid + '": {"Type": ' + $FieldType + ',"Value": [' + $RecordString + '],"FieldId": ' + $Fieldid + '}')
            }
            elseif ($FieldType -eq 11 -or $FieldType -eq 12 -or $FieldType -eq 16 -or $FieldType -eq 23 -or $FieldType -eq 24 -or $FieldType -eq 7) {
                $this.FieldContentRequestJSON.Add('"' + $Fieldid + '": {"Type": ' + $FieldType + ',"Value": [' + $FieldData + '],"FieldId": ' + $Fieldid + '}')
            }
            elseif ($FieldType -eq 4) {
                $this.FieldContentRequestJSON.Add('"' + $Fieldid + '": {"Type": ' + $FieldType + ',"Value": {"ValuesListIds": [' + $FieldData + ']},"FieldId": ' + $Fieldid + '}')
            }
            elseif ($FieldType -eq 8) {
                $tempList = $FieldData.Split(';')
                $UsersString = ""
                $GroupString = ""
                if ($tempList[0] -ne "") {
                    $tempListU = $tempList[0].Split(',')
                    $tempVarU = $tempListU | ForEach-Object { '{"ID": ' + $_ + '}"' }
                    $UsersString = '"UserList": ["' + $tempVarU + '"]'
                }
                else {
                    $UsersString = '"UserList": [],'
                }
                if ($tempList[1] -ne "") {
                    $tempListG = $tempList[1].Split(',')
                    $tempVarG = $tempListG | ForEach-Object { '{"ID": ' + $_ + '}"' }
                    $GroupString = '"GroupList": [' + $tempVarG + '"]"'
                }
                else {
                    $GroupString = '""GroupList": []'
                }
                $this.FieldContentRequestJSON.Add('"' + $Fieldid + '": {"Type": ' + $FieldType + ',"Value": {' + $UsersString + $GroupString + '},"FieldId": ' + $Fieldid + '}')
            }
            elseif ($FieldType -eq 19) {
                $this.FieldContentRequestJSON.Add('"' + $Fieldid + '": {"Type": ' + $FieldType + ',"IpAddressBytes": "' + $FieldData + '","FieldId": ' + $Fieldid + '}')
            }

            Write-Host $this.FieldContentRequestJSON
        }
        catch {
            throw Exception.Message
        }
    }

    [string] Create ([int] $LevelId, [int] $ContentId) {
        if (-not $this.FieldsDataAdded) {
            throw [System.Exception]::new("Fields Data missing. Add using 'AddFieldData' method...")
        }
        else {
            if ($ContentId -gt 0) {
                $this.requestJSON = '{"Content":{"Id": ' + $ContentId + ',"LevelId": ' + $LevelId + ',"FieldContents": {' + ($this.FieldContentRequestJSON -join ",") + '}}}'
            }
            else {
                $this.requestJSON = '{"Content":{"LevelId": ' + $LevelId + ',"FieldContents": {' + ($this.FieldContentRequestJSON -join ",") + '}}}'
            }
        }    
        return $this.requestJSON
    }
}
function PrivateExtractRecordsfromXML($inputRawXML) {
    $xmlObject = [XML]$inputRawXML[0]
    $allLevels = $inputRawXML[1]
    #$var1 = $inputRawXML | ConvertTo-Json -Depth 100
    $FieldDefinitionsList = @()
    
    $FieldDefinitionsArray = $xmlObject.Records.Metadata.FieldDefinitions.FieldDefinition
    foreach ($FieldDefinitionItem in $FieldDefinitionsArray) {
        $FieldDefinition = $FieldDefinitionItem
        $FieldDefinitionsList += [FieldDefinitions]@{
            "id"    = $FieldDefinition.Attributes['id'].Value
            "guid"  = $FieldDefinition.Attributes['guid'].Value
            "name"  = $FieldDefinition.Attributes['name'].Value
            "alias" = $FieldDefinition.Attributes['alias'].Value
        }
        #$FieldDefinitionsList += [FieldDefinitions]::new($obj1.id, $obj1.guid, $obj1.name, $obj1.alias)
    }

    $recordsArray = $xmlObject.Records.Record
    $recordObject = Private_ArcherXMLToJSON($recordsArray, $FieldDefinitionsList, $allLevels)
    $recordJSON = $recordObject | ConvertTo-Json -Depth 100
    return $recordJSON
    Clear-Host
}
function Private_ArcherXMLToJSON($inputXML) {
    $recData = @()
    $data = $inputXML[0]
    $fieldDef = $inputXML[1]
    $allLevels = $inputXML[2]

    foreach ($record in $data) {
        try {
            $FieldData = @()
            $rec = [RecordData]::new()
            $recordIDVal = $record.Attributes["contentId"].Value
            $recordLevelId = $record.Attributes["levelId"].Value
            $levelObject = $allLevels.Value.GetEnumerator() | Where-Object id -EQ $recordLevelId
            $levelName = $levelObject.ModuleName
            $fieldNodes = $record.Field
            foreach ($field in $fieldNodes) {
                try {
                    $fieldIDVal = $field.Attributes['id'].Value
                    $fieldGUIDVal = $field.Attributes['guid'].Value
                    $fieldTypeVal = $field.Attributes['type'].Value

                    $fieldNode = $fieldDef.GetEnumerator() | Where-Object id -EQ $fieldIDVal
                    $fieldName = $fieldNode.name
                    $fieldAlias = $fieldNode.alias

                    if ($fieldTypeVal -eq 1) {
                        $FieldData += [FieldData]@{
                            'id'    = $fieldIDVal
                            'guid'  = $fieldGUIDVal
                            'name'  = $fieldName
                            'alias' = $fieldAlias
                            'value' = $field.InnerText
                            'type'  = $fieldTypeVal
                        }
                    }
                    elseif ($fieldTypeVal -eq 2) {

                        $FieldData += [FieldData]@{
                            'id'    = $fieldIDVal
                            'guid'  = $fieldGUIDVal
                            'name'  = $fieldName
                            'alias' = $fieldAlias
                            'value' = [int]$field.InnerText
                            'type'  = $fieldTypeVal
                        }
                    }
                    elseif ($fieldTypeVal -eq 4) {
                        $valueNodes = $field.ListValues.ListValue
                        $Values = @()
                        foreach ($valueNode in $valueNodes) {
                            $Values += $valueNode.InnerText
                        }
                        $FieldData += [FieldData]@{
                            'id'    = $fieldIDVal
                            'guid'  = $fieldGUIDVal
                            'name'  = $fieldName
                            'alias' = $fieldAlias
                            'value' = $Values
                            'type'  = $fieldTypeVal
                        }
                    }
                    else {
                        $FieldData += [FieldData]@{
                            'id'    = $fieldIDVal
                            'guid'  = $fieldGUIDVal
                            'name'  = $fieldName
                            'alias' = $fieldAlias
                            'value' = $field.InnerText
                            'type'  = $fieldTypeVal
                        }
                    }
                }
                catch {
                    <#Do this if a terminating exception happens#>
                }
            }
            $rec.Data += $FieldData
            $rec.Id = $recordIDVal
            $rec.levelId = $recordLevelId
            $rec.levelName = $levelName
            $childData = @()
            $childRecNodes = $record.record
            if (-not($childRecNodes.count -eq 0)) {
                $childData = Private_ArcherXMLToJSON($childRecNodes, $fieldDef, $allLevels)
                if (-NOT($childData -is [array])) {
                    [object[]] $array1 = $childData
                    $childData = $array1
                }
            }
            $rec.relationship = $childData
            $recData += $rec
            #$recJSON = $recData | ConvertTo-Json -Depth 100
            #$recJSON > $recordIDVal-'.txt'
        }
        catch {
            <#Do this if a terminating exception happens#>
        }
    }
    #$var1 = $recData | ConvertTo-Json -Depth 100
    #$var1 > 'all.txt'
    return $recData
}
class FieldDefinitions {
    [int]$id
    [string]$guid
    [string]$name
    [string]$alias
    <#FieldDefinitions([int]$id, [GUID]$guid, [string]$name, [string]$alias) {
        $this.id = $id
        $this.alias = $alias
        $this.guid = $guid
        $this.name = $name
    }#>
}
class RecordData {
    [int] $id
    [int] $levelId
    [string] $levelName
    $data = @()
    $relationship = @()
}
class FieldData {
    [int]$id
    [string]$guid
    [string]$name
    [string]$alias
    $value = @()
    [int] $type
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
class Environment {
    [string]$BaseURL
    [string]$Username
    [string]$Password
    [string]$Instance
    [string]$UserDomain
    [string]$sessionToken
}
class Logger {
    $fullFileName
    Logger() {
        $logFolder = 'Logs'
        $logFileName = 'Archer.API.Logs'
        $formattedTimestamp = Get-Date -Format ".yyyy.MM.dd.HH.mm.ss"
        $currentLocation = Get-Location
        $currentLocation = $currentLocation.Path
        $logFilePath = $currentLocation + '\' + $logFolder + '\'
        if (-NOT(Test-Path -Path $logFilePath -PathType Container)) {
            New-Item -Path $logFilePath -ItemType Directory
            Write-Host 'Log folder created'
        }
        $this.fullFileName = $logFilePath + $logFileName + $formattedTimestamp + '.txt'
    }
    [void] LogInfo ([string] $logMessage) {        
        
        $logMessage = '[INFO] - ' + $logMessage
        Add-Content $this.fullFileName -Value $logMessage
    }

    [void] LogError ([string] $logMessage) {
        $logMessage = '[ERROR] - ' + $logMessage
        Add-Content $this.fullFileName -Value $logMessage
    }
}

<#  Text = 1,
    Numeric = 2,
    Date = 3,
    ValuesList = 4,
    ExternalLinks = 7,
    RecordPermissions = 8,
    CrossReference = 9,
    Attachment = 11,
    Image = 12,
    Matrix = 16,
    IPAddress = 19,
    RelatedRecords = 23,
    Subform = 24 #>
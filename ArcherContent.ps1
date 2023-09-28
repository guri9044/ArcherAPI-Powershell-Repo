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

class RequestJSON {
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
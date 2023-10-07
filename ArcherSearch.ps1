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

    [AResponse] SearchRecordsByReportJSON([object] $reportIDorGUID, [object] $allLevels) {
        try {
            $response1 = $this.SearchRecordsByReport($reportIDorGUID, 1)
            if ($response1.IsSuccessful -eq $False) {
                throw $response1.Exception
            }
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

<#
Text = 1,
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
Subform = 24
#>



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
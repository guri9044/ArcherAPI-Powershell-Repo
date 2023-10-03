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
            $var1 = PrivateExtractRecordsfromXML($responseResult)
            $okResult = [AResponse]::new($var1, $True, '', $this.response)
            return $okResult
        }
        catch {
            $failResult = [AResponse]::new($_.Exception.Message, $this.response.IsSuccessful, $_.Exception, $this.response)
            return $failResult
        }
    }
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

function PrivateExtractRecordsfromXML($inputRawXML) {
    $xmlObject = [XML]$inputRawXML
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
    $recordObject = PrivateDataConvertfromXML($recordsArray, $FieldDefinitionsList)
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

function PrivateDataConvertfromXML($inputXML) {
    $data = $inputXML[0]
    $fieldDef = $inputXML[1]
    
    $recData = @()
    
    foreach ($record in $data) {
        $FieldData = @()
        $rec = [RecordData]::new() 
        $recordIDVal = $record.Attributes["contentId"].Value
        $recordLevelId = $record.Attributes["levelId"].Value
        $fieldNodes = $record.Field
        foreach ($field in $fieldNodes) {
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
            if ($fieldTypeVal -eq 2) {

                $FieldData += [FieldData]@{
                    'id'    = $fieldIDVal
                    'guid'  = $fieldGUIDVal
                    'name'  = $fieldName
                    'alias' = $fieldAlias
                    'value' = [int]$field.InnerText
                    'type'  = $fieldTypeVal
                }
            }
            if ($fieldTypeVal -eq 4) {
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

        $rec.Data += $FieldData
        $rec.Id = $recordIDVal
        $rec.levelId = $recordLevelId
        $childData        

        $childRecNodes = $record.record
        if (-not($childRecNodes.count -eq 0)) {
            $childData = PrivateDataConvertfromXML($childRecNodes, $fieldDef)
        }
        $rec.relationship = $childData
        $recData += $rec
    }
    $recJSON = $recData | ConvertTo-Json -Depth 100
    $recJSON > recordJSON.txt
    return $recData
}
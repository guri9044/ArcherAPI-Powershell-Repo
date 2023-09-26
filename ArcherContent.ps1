class ArcherContent {
    [string] $inputS
    ArcherContent([string] $inputS) {
        $this.inputS = $inputS
    }
    
    [string] Test() {
        return $this.inputS
    }
}

class RequestJSON {
    [string] $requestJSON = ''
    [bool] $FieldsDataAdded = $false
    [System.Collections.Generic.List[string]] $FieldContentRequestJSON = @()

    RequestJSON([bool] $FieldsDataAdded) {
        $this.FieldsDataAdded = $FieldsDataAdded
    }

    [void] AddFieldData([int] $Fieldid, [int] $FieldType, [string] $FieldData) {
        try {
            # $this.FieldsDataAdded = $True
            if ($FieldType -eq 1 -or $FieldType -eq 2 -or $FieldType -eq 3) 
            {
                $var = '' + $Fieldid + '": {"Type": ' + $FieldType + ',"Value": "' + $FieldData + '","FieldId": ' + $Fieldid + '}'
                $this.FieldContentRequestJSON.Add($var)
            }
            elseif ($FieldType -eq 9) {
                $RecordIdsList = $FieldData.Split(',')
                [System.Collections.Generic.List[string]] $tempVar = @()
                $tempVar = $RecordIdsList | ForEach-Object { '{ "ContentId": ' + $_ + '}' }
                $RecordString = $tempVar -join ','
                $this.FieldContentRequestJSON.Add('' + $Fieldid + '": {"Type": ' + $FieldType + ',"Value": [' + $RecordString + '],"FieldId": ' + $Fieldid + '}')
            }
            elseif ($FieldType -eq 11 -or $FieldType -eq 12 -or $FieldType -eq 16 -or $FieldType -eq 23 -or $FieldType -eq 24 -or $FieldType -eq 7) {
                $this.FieldContentRequestJSON.Add('' + $Fieldid + '": {"Type": ' + $FieldType + ',"Value": [' + $FieldData + '],"FieldId": ' + $Fieldid + '}')
            }
            elseif ($FieldType -eq 4) {
                $this.FieldContentRequestJSON.Add('' + $Fieldid + '": {"Type": ' + $FieldType + ',"Value": {"ValuesListIds": [' + $FieldData + ']},"FieldId": ' + $Fieldid + '}')
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
                $this.FieldContentRequestJSON.Add('' + $Fieldid + '": {"Type": ' + $FieldType + ',"Value": {' + $UsersString + $GroupString + '},"FieldId": ' + $Fieldid + '}')
                #$this.FieldContentRequestJSON.Add(""$Fieldid": {"Type": $FieldType,"Value": {$UsersString, $GroupString},"FieldId": $Fieldid}")
            }
            elseif ($FieldType -eq 19) {
                $this.FieldContentRequestJSON.Add('' + $Fieldid + '": {"Type": ' + $FieldType + ',"IpAddressBytes": "' + $FieldData + '","FieldId": ' + $Fieldid + '}')
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
                $this.requestJSON = '{"Content":{"Id": ' + $ContentId + ',"LevelId": ' + $LevelId + ',"FieldContents": {"' + ($this.FieldContentRequestJSON -join ",") + '}}}'
            }
            else {
                $this.requestJSON = '{"Content":{"LevelId": ' + $LevelId + ',"FieldContents": {"' + ($this.FieldContentRequestJSON -join ",") + '}}}'
            }
        }    
        return $this.requestJSON
    }
    
}

$rJSON = [RequestJSON]::new($True)
$rJSON.AddFieldData( 567 , 1 , 'Hello' )
$reqJSON = $rJSON.Create(5,0)
Write-Host $reqJSON

$var1 = $reqJSON | ConvertFrom-Json

Write-Host 'End'
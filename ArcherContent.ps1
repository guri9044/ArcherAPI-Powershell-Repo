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

    RequestJSON() {
        Write-Host 'Archer Request JSON Class created'
    }

    [void] AddFieldData([int] $Fieldid, [int] $FieldType, [string] $FieldData) {
        $this.FieldsDataAdded = $True
        if ($FieldType -eq 1 -or $FieldType -eq 2 -or $FieldType -eq 3) {
            $this.FieldContentRequestJSON.Add('\"' + $Fieldid + '\": {\"Type\": ' + $FieldType + ',\"Value\": \"' + $FieldData + '\",\"FieldId\": ' + $Fieldid + '}')
        }
        elseif ($FieldType -eq 9) {
            $RecordIdsList = $FieldData.Split(',')
            #[System.Collections.Generic.List[string]] $tempVar = @()
            $tempVar2 = $RecordIdsList | ForEach-Object { '{ "ContentId": ' + $_ + '}' }
            $RecordString = $tempVar2 -join ','
            $this.FieldContentRequestJSON.Add('\"' + $Fieldid + '\": {\"Type\": ' + $FieldType + ',\"Value\": [' + $RecordString + '],\"FieldId\": ' + $Fieldid + '}')
        }
        elseif ($FieldType -eq 11 -or $FieldType -eq 12 -or $FieldType -eq 16 -or $FieldType -eq 23 -or $FieldType -eq 24 -or $FieldType -eq 7) {
            $this.FieldContentRequestJSON.Add('\"' + $Fieldid + '\": {\"Type\": ' + $FieldType + ',\"Value\": [' + $FieldData + '],\"FieldId\": ' + $Fieldid + '}')
        }
        elseif ($FieldType -eq 4) {
            $this.FieldContentRequestJSON.Add('\"' + $Fieldid + '\": {\"Type\": ' + $FieldType + ',\"Value\": {\"ValuesListIds\": [' + $FieldData + ']},\"FieldId\": ' + $Fieldid + '}')
        }
        elseif ($FieldType -eq 8) {
            $tempList = $FieldData.Split(';')
            $UsersString = ""
            $GroupString = ""
            if ($tempList[0] -ne "") {
                $tempListU = $tempList[0].Split(',')
                $tempVarU = $tempListU | ForEach-Object { '{\"ID\": ' + $_ + '}"' }
                $UsersString = '\"UserList\": ["' + $tempVarU + '"]'
            }
            else {
                $UsersString = '\"UserList\": [],'
            }
            if ($tempList[1] -ne "") {
                $tempListG = $tempList[1].Split(',')
                $tempVarG = $tempListG | ForEach-Object { '{\"ID\": ' + $_ + '}"' }
                $GroupString = '\"GroupList\": [' + $tempVarG + '"]"'
            }
            else {
                $GroupString = '"\"GroupList\": []'
            }
            $this.FieldContentRequestJSON.Add('\"' + $Fieldid + '\": {\"Type\": ' + $FieldType + ',\"Value\": {' + $UsersString + $GroupString + '},\"FieldId\": ' + $Fieldid + '}')
            #$this.FieldContentRequestJSON.Add("\"$Fieldid\": {\"Type\": $FieldType,\"Value\": {$UsersString, $GroupString},\"FieldId\": $Fieldid}")
        }
        elseif ($FieldType -eq 19) {
            $this.FieldContentRequestJSON.Add('\"' + $Fieldid + '\": {\"Type\": ' + $FieldType + ',\"IpAddressBytes\": \"' + $FieldData + '\",\"FieldId\": ' + $Fieldid + '}')
        }
    }
}


Clear-Host

$aC = [ArcherContent]::new('Holaa');
$th = $aC.Test()
Write-Host $tH

$rJSON = [RequestJSON]::new
$rJSON.AddFieldData(567,1,'Hello')

Write-Host 'End'

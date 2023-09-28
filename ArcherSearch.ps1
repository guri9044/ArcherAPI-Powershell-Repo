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
            PrivateExtractRecordsfromXML($responseResult)



            $okResult = [AResponse]::new($responseResult, $True, '', $this.response)
            return $okResult
        }
        catch {
            $failResult = [AResponse]::new($_.Exception.Message, $this.response.IsSuccessful, $_.Exception, $this.response)
            return $failResult
        }
    }
}

function PrivateExtractRecordsfromXML([string] $inputXML) {
    $xmlObject = [XML]$inputXML
    $blankJsonObject = @{}
    $jsonData = $blankJsonObject | ConvertTo-Json
    $countOfRecords = $xmlObject.Records.Attributes["count"].Value
    Clear-Host
}
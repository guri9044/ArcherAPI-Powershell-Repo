Import-Module .\ArcherAPI.ps1
Clear-Host
try {

    Write-Host " Hello Neo " -ForegroundColor Red -BackgroundColor Yellow
    #Write-Host "Hello Neo" -NoNewline -ForegroundColor Yellow

    $logger = [Logger]::new()
    class User {
        [string]$ID
        [string]$Title
        [string]$FirstName
        [string]$MiddleName
        [string]$LastName
        [string]$UserName
        [int]$AccountStatus = 1  
        User([string]$ID, [string] $Title, [string]$FirstName, [string]$MiddleName, [string]$LastName, [string]$UserName) {
            $this.ID = $ID
            $this.Title = $Title
            $this.FirstName = $FirstName
            $this.MiddleName = $MiddleName
            $this.LastName = $LastName
            $this.UserName = $UserName
        }
    }

    class Root {
        [User]$User
        Root([User]$User) {
            $this.User = $User
        }
    }

    <#
# Create a list to hold the User objects
$listOfUsers = New-Object 'System.Collections.Generic.List[User]'

# Create some User objects and add them to the list
$user1 = New-Object User 1, 'Mr', "John", '', "Doe", 'johnd'
$user2 = New-Object User 2, 'Ms', "Jane", '', "Doe", 'janed'

$listOfUsers.Add($user1)
$listOfUsers.Add($user2)

# Display the list of users
$listOfUsers
foreach ($user in $listOfUsers) {
    $logger.LogInfo('First Name - ' + $user.FirstName + ', Last Name - ' + $user.LastName)
    <# $user is the current item 
}


$my = [PSCustomObject]@{
    $baseURL      = 'http://104.208.113.31'
    $username     = 'webapi'
    $password     = 'Archer@123'
    $userDomain   = ""
    $sessionToken = ""
}

    
    $archerAPI = [ArcherAuthentication]::new($baseURL)
    $loginResponse = $archerAPI.Login( 'IU', 'Archer@123', '700030', '')
    if ($loginResponse.IsSuccessful -eq $False) {
        $logger.LogError('Authentication Unsuccessful ' + $loginResponse.Exception)
        throw 'Authentication Unsuccessful ' + $loginResponse.Exception
    }
    $sessionToken = $archerAPI.sessionToken
    $logger.LogInfo("Authentication done - $sessionToken")
    Write-Host "Authentication done - $sessionToken"
#>
    #$archerContent = [ArcherContent]::new('http://192.168.44.10/Archer',$sessionToken)
    <#Clear-Host
#get record
$record = $archerContent.Record_Get(205555).Value
$record | ConvertTo-Json #>

    <#Clear-Host
#create record - create request json first, then pass request json to Record_Create method
$rJSON = [RequestJSON]::new($True)
$rJSON.AddFieldData( 2974 , 1 , 'API Test Company' )
$rJSON.AddFieldData( 2973 , 1 , 'API Test Company' )
$rJSON.AddFieldData( 2972 , 1 , 'API Test Company' )
$reqJSON = $rJSON.Create(34,0)
Write-Host $reqJSON
$recordID  = $archerContent.Record_Create($reqJSON).Value #>

    <#
$aO = [ArcherSearch]::new($baseURL, $sessionToken)
$aL = [ArcherLevel]::new($baseURL, $sessionToken)
$allLevels = $aL.Level_Get()
$ko = $aO.SearchRecordsByReportJSON(13794).Value
#>
    $baseURL = 'https://riotinto.archerirm.com.au'
    $sessionToken = 'BB26B15467055A71B6C901BCED021C86'
    $aU = [ArcherUser]::new($baseURL, $sessionToken)
    #$au.User_Get()
    $csvPath = "new.csv"
    $userArray = Import-Csv -Path $csvPath
    foreach ($user in $userArray) {
        #Write-Output $user.ID '-' $user.FirstName -nonewline -ForegroundColor Yellow
        $user1 = New-Object User $user.ID, $user.Title, $user.FirstName, $user.MiddleName, $user.LastName, $user.Username
        $userRoot = New-Object Root $user1
        $userJSON = $userRoot | ConvertTo-Json
        $userUpdateResponse = $au.User_Update($userJSON)
        if ($userUpdateResponse.IsSuccessful -eq $False) {
            $logger.LogError('Authentication Unsuccessful ' + $loginResponse.Exception)
        }
        $logger.LogInfo("User updated - $userUpdateResponse.value")
    }
}
catch {
    $logger.LogError($_.Exception.Message)
}
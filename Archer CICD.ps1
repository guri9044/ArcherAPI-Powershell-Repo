Import-Module .\ArcherAPI.ps1
$config
try {
    $configFile = ".\CICD config.json"
    try {
        $config = Get-Content -Path $configFile | ConvertFrom-Json
    }
    catch {
        throw "Unable to load configuration file"
    }

    Write-Host "Please choose option :" "1. Download Application Details" "2. Download Role Details" "3. Download Group Details" "4. Download Notification Details" "5. Migrate Changes to another environment"
    $option = Read-Host 
    switch ($option) {
        1 {}
        2 {}
        3 {}
        4 {}
        5 {}
        default { 
            "Please select correct option..."
            Start-Sleep -Seconds 5
            exit
        }
    }

}
catch {

}

function DownloadApplicationDetails() {

}

function DownloadRoleDetails() {

}

function DownloadGroupnDetails() {

}

function DownloadNotificationDetails() {

}
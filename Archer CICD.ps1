Import-Module .\ArcherAPI.ps1
function DownloadApplicationDetails ($my) {
    $archerAPI = [ArcherAuthentication]::new($my.BaseURL)
    $loginResponse = $archerAPI.Login( $my.Username, $my.Password, $my.Instance, $my.UserDomain)
    if ($loginResponse.IsSuccessful -eq $False) {
        throw 'Authentication Unsuccessful ' + $loginResponse.Exception
    }
    $sessionToken = $archerAPI.sessionToken
    Write-Host "Authentication done - $sessionToken"

    $levelAPI = [ArcherLevel]::new($my.BaseURL, $sessionToken)
    $levelByModuleResponse = $levelAPI.Level_Get();
    if ($levelByModuleResponse.IsSuccessful -eq $False) {
        throw 'Unable to download Application/Level details' + $loginResponse.Exception
    }
    $env = $my.Environment
    $levelByModuleResponse.Value | Export-Csv -Path "Downloads\$env Applications.csv" -NoTypeInformat
}
function DownloadRoleDetails($my) {
    $archerAPI = [ArcherAuthentication]::new($my.BaseURL)
    $loginResponse = $archerAPI.Login( $my.Username, $my.Password, $my.Instance, $my.UserDomain)
    if ($loginResponse.IsSuccessful -eq $False) {
        throw 'Authentication Unsuccessful ' + $loginResponse.Exception
    }
    $sessionToken = $archerAPI.sessionToken
    Write-Host "Authentication done - $sessionToken"

    $levelAPI = [ArcherLevel]::new($my.BaseURL, $sessionToken)
    $levelByModuleResponse = $levelAPI.Level_Get();
    if ($levelByModuleResponse.IsSuccessful -eq $False) {
        throw 'Unable to download Role details' + $loginResponse.Exception
    }
    $env = $my.Environment
    $levelByModuleResponse.Value | Export-Csv -Path "Downloads\$env Roles.csv" -NoTypeInformat
}
function DownloadGroupnDetails($my) {
    $archerAPI = [ArcherAuthentication]::new($my.BaseURL)
    $loginResponse = $archerAPI.Login( $my.Username, $my.Password, $my.Instance, $my.UserDomain)
    if ($loginResponse.IsSuccessful -eq $False) {
        throw 'Authentication Unsuccessful ' + $loginResponse.Exception
    }
    $sessionToken = $archerAPI.sessionToken
    Write-Host "Authentication done - $sessionToken"

    $levelAPI = [ArcherLevel]::new($my.BaseURL, $sessionToken)
    $levelByModuleResponse = $levelAPI.Level_Get();
    if ($levelByModuleResponse.IsSuccessful -eq $False) {
        throw 'Unable to download Group details' + $loginResponse.Exception
    }
    $env = $my.Environment
    $levelByModuleResponse.Value | Export-Csv -Path "Downloads\$env Groups.csv" -NoTypeInformat
    Write-Host "Please choose option :" "1. Source" "2. Target"
}
function DownloadNotificationDetails($my) {
    $archerAPI = [ArcherAuthentication]::new($my.BaseURL)
    $loginResponse = $archerAPI.Login( $my.Username, $my.Password, $my.Instance, $my.UserDomain)
    if ($loginResponse.IsSuccessful -eq $False) {
        throw 'Authentication Unsuccessful ' + $loginResponse.Exception
    }
    $sessionToken = $archerAPI.sessionToken
    Write-Host "Authentication done - $sessionToken"

    $notificationAPI = [ArcherNotification]::new($my.BaseURL, $sessionToken)
    $notificationResponse = $notificationAPI.Notification_Get()
    if ($notificationResponse.IsSuccessful -eq $False) {
        throw 'Unable to download Notification details' + $loginResponse.Exception
    }
    $env = $my.Environment
    $data = $notificationResponse.Value | ConvertFrom-Json
    $data = $data.value
    $data | Export-Csv -Path "Downloads\$env Notifications.csv" -NoTypeInformat
}

$config
try {
    $currentLocation = Get-Location
    $currentLocation = $currentLocation.Path
    $logFilePath = $currentLocation + '\Downloads\'
    if (-NOT(Test-Path -Path $logFilePath -PathType Container)) {
        New-Item -Path $logFilePath -ItemType Directory
    }
    $configFile = ".\CICD config.json"
    try {
        $config = Get-Content -Path $configFile | ConvertFrom-Json
    }
    catch {
        throw "Unable to load configuration file"
    }

    Write-Host "Select Option :`n1. Download Application Details`n2. Download Role Details`n3. Download Group Details`n4. Download Notification Details`n5. Migrate Changes to another environment"
    $option = Read-Host 
    Write-Host "Select Environment :`n1. Source`n2. Target"
    $envOption = Read-Host
    switch ($option) {
        1 {
            $inputP
            switch ($envOption) {
                1 { 
                    $inputP = $config.Environments | Where-Object { $_.Environment -eq "Source" }
                     
                }
                2 { 
                    $inputP = $config.Environments | Where-Object { $_.Environment -eq "Target" }
                }
            }
            $var = DownloadApplicationDetails($inputP)
        }
        2 {
            $inputP
            switch ($envOption) {
                1 { 
                    $inputP = $config.Environments | Where-Object { $_.Environment -eq "Source" }
                     
                }
                2 { 
                    $inputP = $config.Environments | Where-Object { $_.Environment -eq "Target" }
                }
            }
            $var = DownloadRoleDetails($inputP)
        }
        3 {
            $inputP
            switch ($envOption) {
                1 { 
                    $inputP = $config.Environments | Where-Object { $_.Environment -eq "Source" }
                     
                }
                2 { 
                    $inputP = $config.Environments | Where-Object { $_.Environment -eq "Target" }
                }
            }
            $var = DownloadGroupnDetails($inputP)
        }
        4 {
            $inputP
            switch ($envOption) {
                1 { 
                    $inputP = $config.Environments | Where-Object { $_.Environment -eq "Source" }
                     
                }
                2 { 
                    $inputP = $config.Environments | Where-Object { $_.Environment -eq "Target" }
                }
            }
            $var = DownloadNotificationDetails($inputP)
        }
        default { 
            "Please select correct option..."
            Start-Sleep -Seconds 5
            exit
        }
    }

}
catch {
    Write-Host $_.Exception.Message
}
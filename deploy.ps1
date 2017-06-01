# function Set-ValidConfigFile($environment, $serverNumber, $path, $baseFileName, $vendorPrefix, $extension)
# {
#     #systemtest
#     $envPart = $environment -replace " ", ""

#     #Web.config
#     $outputConfig = $baseFileName + "." + $extension

#     #web.CC-systemtest.config
#     $envSpecifiedConfig = $baseFileName + "." + $vendorPrefix + "-" + $envPart + "." + $extension
#     #TestClientPath\web.CC-systemtest.config
#     $envSpecifiedConfig = Join-Path $path $envSpecifiedConfig

#     $serverSpecifiedConfig = $baseFileName + "." + $vendorPrefix + "-" + $envPart + "." + $serverNumber + "." + $extension
#     $serverSpecifiedConfig = Join-Path $path $serverSpecifiedConfig

#     #if(Test-Path -Path $serverSpecifiedConfig) {
#         Write-Host "Found file: $serverSpecifiedConfig"
#         $inputConfig = $serverSpecifiedConfig
#     #}
#     #elseif(Test-Path -Path $envSpecifiedConfig) {
#      #   Write-Host "Found file: $envSpecifiedConfig"
#       #  $inputConfig = $envSpecifiedConfig
#     #}
#     #else {
#     #    throw "Config file not found ($serverSpecifiedConfig nor $envSpecifiedConfig)"
#     #}

#     Write-Host "Renaming file: $inputConfig"
#     Write-Host "  to: $outputConfig"
#     Rename-Item -Path $inputConfig -NewName $outputConfig

#     $removeItemsPattern = Join-Path $path "$baseFileName.*.$extension"
#     Remove-Item $removeItemsPattern -Exclude $outputConfig
# }

# Set-ValidConfigFile "SystemTest" "server007" "C:\Nowy folder" "Web" "CC" "config"

$Backup_folder = "C:\Nowy folder\backup"

robocopy /s "C:\Nowy folder\wazne 1" $Backup_folder
robocopy /s "C:\Nowy folder\wazne 2" $Backup_folder\WebTestClient
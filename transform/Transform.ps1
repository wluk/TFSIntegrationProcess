# <#
# .SYNOPSIS

# .DESCRIPTION

# .NOTES
# #>

function SetTransformFiles($typesConfig, $path) {
    foreach ($type in $typesConfig) {
        if (Test-Path -Path $path) {
            $filesConfig = Get-ChildItem -filter "$typeConfig.*.config" -File

            Write-Host "In path $path found: $filesConfig"

            foreach ($file in $filesConfig) {
                TransformConfigFiles "$path\$typeConfig.config" $file.FullName
            }
        }
        else {
            Write-Host "$path path don't exist"
        }
    }
}

function TransformConfigFiles($configPath, $transformPath) {
    try {
        Write-Host "Start transform $transformPath to $configPath"
        $XmlTransformPath = $PSScriptRoot + "\Microsoft.Web.XmlTransform.dll"
        Add-Type -LiteralPath $XmlTransformPath
        
        $doc = New-Object Microsoft.Web.XmlTransform.XmlTransformableDocument
        $doc.PreserveWhiteSpace = $true
        $doc.Load($configPath)

        $transform = New-Object Microsoft.Web.XmlTransform.XmlTransformation($transformPath)
       
        if ($transform.Apply($doc) -eq $false) {
            throw "Transformation failed."
        }

        $doc.Save($transformPath + "_NEW");
        Write-Host "Transformed $transformPath"
    }
    catch {
        Write-Output $Error[0].Exception
    }
}

#Transforms source_binaries with configuration related to target environment

Write-Host "Transforms source_binaries with configuration related to target environment"

#Web
$webConfigsType = @("AppSettings", "log4net", "Web")
$sourceDir = $env:Build_SourcesDirectory + "\APP\WEB"
Write-Host "Start transform WEB, fransform config: $webConfigsType on path: $sourceDir"
SetTransformFiles $webConfigsType $sourceDir

#Server
$serverConfigsType = @("AppSettings", "log4net", "Yellow.Server.exe", "quartz-job")
$sourceDir = $env:Build_SourcesDirectory + "\APP\SERVER"
Write-Host "Start transform SERVER, fransform config: $serverConfigsType on path: $sourceDir"
SetTransformFiles $serverConfigsType $sourceDir

#TestClient
$testClientsConfigType = @("Web")
$sourceDir = $env:Build_SourcesDirectory + ".\TEST\CLIENT"
Write-Host "Start transform TestClient, fransform config: $testClientsConfigType on path: $sourceDir"
SetTransformFiles $testClientsConfigType $sourceDir
# <#
# .SYNOPSIS

# .DESCRIPTION

# .NOTES
# #>

function SetTransformFiles($configTypes, $path) {
    foreach ($configType in $configTypes) {
        if (Test-Path -Path $path) {
            $filesConfig = Get-ChildItem -path $path -filter "$configType.*.config" -File

            Write-Host "In path $path found: $filesConfig"

            foreach ($file in $filesConfig) {
                TransformConfigFiles "$path\$configType.config" $file.FullName
            }
        }
        else {
            Write-Host "$path path don't exist"
        }
    }
}

function TransformConfigFiles($configPath, $transformPath) {
    try {
        Write-Host "Start transformation $transformPath to $configPath"
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
$sourceDir = "C:\Users\luwe\Documents\Visual Studio 2015\Projects\WebAppCI\APP\WEB"
#$sourceDir = $env:Build_SourcesDirectory + "\APP\WEB"
Write-Host "Start transform WEB, fransform config: $webConfigsType on path: $sourceDir"
SetTransformFiles $webConfigsType $sourceDir

#Server
$serverConfigsType = @("AppSettings", "log4net", "Yellow.Server.exe", "quartz-job")
$sourceDir = "C:\Users\luwe\Documents\Visual Studio 2015\Projects\WebAppCI\APP\SERVER"
#$sourceDir = $env:Build_SourcesDirectory + "\APP\SERVER"
Write-Host "Start transform SERVER, fransform config: $serverConfigsType on path: $sourceDir"
SetTransformFiles $serverConfigsType $sourceDir

#TestClient
$testClientsConfigType = @("Web")
$sourceDir = "C:\Users\luwe\Documents\Visual Studio 2015\Projects\WebAppCI\TEST\CLIENT"
#$sourceDir = $env:Build_SourcesDirectory + "\TEST\CLIENT"
Write-Host "Start transform TestClient, fransform config: $testClientsConfigType on path: $sourceDir"
SetTransformFiles $testClientsConfigType $sourceDir
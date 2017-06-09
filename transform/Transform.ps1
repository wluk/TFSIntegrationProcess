# <#
# .SYNOPSIS

# .DESCRIPTION

# .NOTES
# #>

function SetTypeTransformFiles($typesConfig, $sourceDir) {
    foreach ($type in $typesConfig) {
        SetTransformFiles $type $sourceDir
    }
}

function SetTransformFiles($typeConfig, $sourceDir) {
    if (Test-Path -Path $sourceDir) {
        $filesConfig = Get-ChildItem -filter "$typeConfig.*.config" -File

        Write-Host "In path: $sourceDir found: $filesConfig"

        foreach ($file in $filesConfig) {
            TransformConfigFiles "$sourceDir\$typeConfig.config" $file.FullName
        }
    }
    else {
        Write-Host "$sourceDir path don't exist"
    }
}

function TransformConfigFiles($configPath, $transformPath) {
    try {
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
        Write-Host "Transform $transformPath to $configPath"
    }
    catch {
        Write-Output $Error[0].Exception
    }
}

#Transforms source_binaries with configuration related to target environment

Write-Host "Transforms source_binaries with configuration related to target environment"

#Web
$webConfigType = @("AppSettings", "log4net", "Web")
#$Website
$dirPath = $env:Build_SourcesDirectory + "\APP\WEB"
Write-Host "Start transform WEB, fransform config: $webConfigType on path: $dirPath"
SetTypeTransformFiles $webConfigType $dirPath

#Server
$serverConfigType = @("AppSettings", "log4net", "Yellow.Server.exe", "quartz-job")
#$Website\Server
$dirPath = $env:Build_SourcesDirectory + "\APP\SERVER"
Write-Host "Start transform SERVER, fransform config: $webConfigType on path: $dirPath"
SetTypeTransformFiles $webConfigType $dirPath

#TestClient
$testClientConfigType = @("Web")
#$WebsiteTestClient
$dirPath = $env:Build_SourcesDirectory + ".\TEST\CLIENT"
Write-Host "Start transform TestClient, fransform config: $webConfigType on path: $dirPath"
SetTypeTransformFiles $webConfigType $dirPath

Write-Host $env:Build_SourcesDirectory

SetTypeTransformFiles $webConfigType
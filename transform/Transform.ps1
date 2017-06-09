# <#
# .SYNOPSIS

# .DESCRIPTION

# .NOTES
# #>

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
    }
    catch {
        Write-Output $Error[0].Exception
    }
}

function SetTransformFiles($typeConfig) {
    if (Test-Path -Path $sourceDir) {
        $filesConfig = Get-ChildItem -filter "$typeConfig.*.config" -File

        foreach ($file in $filesConfig) {
            TransformConfigFiles "$sourceDir\$typeConfig.config" $file.FullName
        }
    }
}

function SetTypeTransformFiles($typesConfig) {
    foreach ($type in $typesConfig) {
        SetTransformFiles $type
    }
}

# $configPath = $PSScriptRoot + "\AppSettings.config"
# $transformPath = $PSScriptRoot + "\AppSettings.CC-SystemTest.config"

# XmlDocTransform $configPath $transformPath


#Transforms source_binaries with configuration related to target environment

Write-Host "Transforms source_binaries with configuration related to target environment"

# #Web
# $webConfigType = @("AppSettings", "log4net", "Web")
# #$Website
# $sourceDir = "C:\Users\luwe\Desktop\transform"
# SetTypeTransformFiles $webConfigType

# #Server
# $serverConfigType = @("AppSettings", "log4net", "Yellow.Server.exe", "quartz-job")
# #$Website\Server
# $sourceDir = "C:\Users\luwe\Desktop\transform"
# SetTypeTransformFiles $webConfigType

# #TestClient
# $testClientConfigType = @("Web")
# #$WebsiteTestClient
# $sourceDir = "C:\Users\luwe\Desktop\transform"

Write-Host $env:Build_SourcesDirectory 

SetTypeTransformFiles $webConfigType
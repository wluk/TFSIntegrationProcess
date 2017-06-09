$Website = "C:\Users\luwe\Documents\Visual Studio 2015\Projects\WebAppCI\WebAppCI\_App_Offline.htm"
$ex = Test-Path -path "$Website"
# if ($ex -eq $true) {
#     # Copy-Item $Website\_App_Offline.htm $Website\App_Offline.htm
#     # Write-Host "1"
# }
# else {
#     # Write-Host "There was no _App_Offline file for " + $Website
# }

If (Test-Path $Website) {
    Copy-Item $Website\_App_Offline.htm $Website\App_Offline.htm
    Write-Host "1"
} 
Else {
    Write-Host "There was no _App_Offline file for " + $Website
}
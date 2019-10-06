###################################################
# Add the release log file.
#--------------------------------------------- 
Param
(
    [Parameter(Mandatory=$true)]
    [string]$releaseLogFilePath,
    [Parameter(Mandatory=$true)]
    [string]$releaseName  
)
if (!(Test-Path -Path $releaseLogFilePath))
{
    New-Item $releaseLogFilePath -ItemType File
    Write-Host "Add the release log file [ $releaseLogFilePath] Successfully" -ForegroundColor Blue
    #------------------
}
Set-Content $releaseLogFilePath $releaseName

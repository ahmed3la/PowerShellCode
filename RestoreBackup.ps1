Param
(
    [Parameter(Mandatory=$true)]
    [string]$PathReleaseLogFile,
    [Parameter(Mandatory=$true)]
    [string]$PathbackupFolder,
    [Parameter(Mandatory=$true)]
    [string]$ExtractTo,
    [Parameter(Mandatory=$true)]
    [string]$DeploymentPath

) 
Add-Type -AssemblyName System.IO.Compression.FileSystem 
Add-Type -A System.IO.Compression.FileSystem

function getBackupFileName()
{
    param([string] $path)

    return Get-Content "$path" | Select-Object -Last 1
}

function unZip
{
    param([string]$_sourceZip, [string]$_extractTo,[string] $_fileName)
    
    $extractTo="$_extractTo\$_fileName\"
    #Write-Host "H $extractTo"
    if(Test-Path $extractTo)
    {
        Remove-Item -Path "$extractTo*" -Recurse
    }
    else
    {
        New-Item -ItemType directory -Path $extractTo
    }
     
     Write-Output "_sourceZip: $_sourceZip  ====> extractTo: $extractTo" -ForegroundColor Blue 
    [System.IO.Compression.ZipFile]::ExtractToDirectory($_sourceZip, $extractTo)
}

function CopyToDeployFolder
{ 
    param([string]$_backupPath, [string]$_deployPath)

    Write-Host "Copy backup to the deploy folder $_backupPath  ==> $_deployPath" -ForegroundColor Blue 
 
    if(Test-Path $_deployPath)
    { 
        Remove-Item -Path "$_deployPath*" -Recurse
        #Copy-item -Force -Recurse -Verbose "$_backupPath\*" -Destination $_deployPath
        Copy-Item -Path "$_backupPath\*" -Destination "$_deployPath" -Recurse
        return $true
    }
    else
    {
        return $false
    }
}
 

if(Test-Path $ExtractTo)
{
     $filename= getBackupFileName($PathReleaseLogFile)
      
     $backup ="$ExtractTo\$filename"
     $SourceZip = "$PathbackupFolder\$filename.zip"

     if(Test-Path "$PathbackupFolder\$filename.zip")
     {
        unZip $SourceZip  $ExtractTo $filename
        Write-Host "The backup extract to work dir" -ForegroundColor Blue 
        #----------------------
        #Copy Backup to deploy folder
        $result =CopyToDeployFolder "$backup" "$DeploymentPath"
        
        if(($result) )
        {
            Write-Host "The restore backup has been done." -ForegroundColor Blue 
        }
        else
        { 
            throw [System.IO.FileNotFoundException] "The restore backup fails"
        }

     }
     else
     {
        throw [System.IO.FileNotFoundException] "Could not find the backup file $SourceZip"
         
     }
      
}
else
{
    Write-Host "That is the first deployment" -ForegroundColor Blue 
}

 
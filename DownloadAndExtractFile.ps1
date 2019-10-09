###################################################
# DownloadReportViewer_Zip&Extract
#---------------------------------------------
Param
(
    [Parameter(Mandatory=$true)]
    [string]$Url_Zip,
    [Parameter(Mandatory=$true)]
    [string]$DownloadToPath,
    [Parameter(Mandatory=$true)]
    [string]$ExtractToPath  
)

Add-Type -AssemblyName System.IO.Compression.FileSystem
 
function Download
{
    param([string]$url, [string]$destnation)
    Write-Host "This task will downloaded : "$url ":==>" $destnation
    Invoke-WebRequest $url -OutFile $destnation 
    Write-Host "The file has downloaded successfully"
}
 
function Unzip
{
    param([string]$zipfile, [string]$outpath)
    Write-Host "This task will extracting " $zipfile ":==>" $outpath
    [System.IO.Compression.ZipFile]::ExtractToDirectory($zipfile, $outpath)
    Write-Host "The file has extracted successfully"
}

function getFileNameWithEx
{
    param([string] $filePath)
    $splitPath = $filePath.Split("/")
     
    if($splitPath.Length -gt 0)
    { 
        $name=$splitPath[$splitPath.Length-1] 
        return $name
        
    } 
}

function getFileName
{
    param([string] $fullName)

    $splitName = $fullName.Split(".")
     
    if($splitName.Length -gt 0)
    {  
        return $splitName[0]
    } 
}

$fileNameWithEx=getFileNameWithEx($Url_Zip)
$fileName= getFileName($fileNameWithEx)



if(!(Test-Path -Path $ExtractToPath"\"$fileName))
{
    Download $Url_Zip $DownloadToPath$fileNameWithEx
    Unzip $DownloadToPath$fileNameWithEx $ExtractToPath
}
else
{
    Write-Host $ExtractToPath$fileName
    Write-Host "The file already exists!" $fileName
}

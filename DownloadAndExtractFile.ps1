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

    Invoke-WebRequest $url -OutFile $destnation 
    Write-Host "The file has downloaded successfully"
}
 
function Unzip
{
    param([string]$zipfile, [string]$outpath)

    [System.IO.Compression.ZipFile]::ExtractToDirectory($zipfile, $outpath)
    Write-Host "The file has extracted successfully"
}

function getFileName
{
    param([string] $filePath)
    $splitPath = $filePath.Split("\")
     
    if($splitPath.Length -gt 0)
    { 
        $name=$splitPath[$splitPath.Length-1].Split(".")
        if($name -gt 0)
        {
             return $name[0]
        }
    } 
}

$fileName= getFileName($DownloadToPath)
Write-Host $ExtractToPath"\"$fileName

if(!(Test-Path -Path $ExtractToPath"\"$fileName))
{
    Download $Url_Zip $DownloadToPath
    Unzip $DownloadToPath $ExtractToPath
}
else
{
    Write-Host "The file already exists!"$ExtractToPath
}

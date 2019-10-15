Param
(
    [Parameter(Mandatory=$true)]
    [string]$SourceFile,
    [Parameter(Mandatory=$true)]
    [string]$ZipPath  
)
 
Add-Type -AssemblyName System.IO.Compression.FileSystem 

function zip
{
    param([string]$sourceFile, [string]$inPath)
    
    [System.IO.Compression.ZipFile]::CreateFromDirectory($sourceFile, $inPath)
}
if(Test-Path $SourceFile)
{
    zip $SourceFile  $ZipPath
    Write-Host "The backup of the build has been done."
}
else
{
    Write-Host "That is the first deployment"
} 

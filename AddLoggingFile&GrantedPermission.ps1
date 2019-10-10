###################################################
# Add log file
#---------------------------------------------
 Param
(
    [Parameter(Mandatory=$true)]
    [string]$logFolderPath,
    [Parameter(Mandatory=$true)]
    [string]$logFileName ,
    [Parameter(Mandatory=$true)]
    [string]$iisUser
)
$filePath = "$logFolderPath\$logFileName"
$fileName,$extensionTypes = $filePath.split('.')

if (!(Test-Path -Path $logFolderPath ))
{
    New-Item $logFolderPath -ItemType Directory
    Write-Host "Add log Directory [ $logFolderPath ] Successfully"
}
if (!(Test-Path -Path $filePath ))
{
    New-Item $filePath -ItemType File
    Set-Content $filePath 'This file add with TFS'
    Write-Host "Add log file [ $filePath ] Successfully"
}
else 
{ 
    $Date=Get-Date
    $DateStr = '{0:yyyyMMdd_HH-mm}' -f ($Date)
    
    $destination  = "$fileName$DateStr.$extensionTypes"  
	Write-Host "is beginning get a backup of the file " $destination
    Copy-Item $filePath  $destination
    Write-Host "The Backup has finished successfully " $filePath    
    
    Set-Content $filePath 'This file add with TFS' -force
    Write-Host "The content has cleared successfully " $filePath    
}


 # Add access control at log folder
    
    #$myGroup = "IIS_IUSRS"
    $acl = Get-Acl $logFolderPath 
    $rule = New-Object System.Security.AccessControl.FileSystemAccessRule("$iisUser", "Modify", "Allow")
    $acl.AddAccessRule($rule)
    $rule = New-Object System.Security.AccessControl.FileSystemAccessRule("$iisUser", "ReadAndExecute", "Allow")
    $acl.AddAccessRule($rule)
    Set-Acl $logFolderPath $acl

    Write-Host "Add access control at $logFolderPath successfully"

 # Add access control at log file
    
    #$myGroup = "IIS_IUSRS"
    $acl = Get-Acl $filePath 
    $rule = New-Object System.Security.AccessControl.FileSystemAccessRule("$iisUser", "Modify", "Allow")
    $acl.AddAccessRule($rule)
    $rule = New-Object System.Security.AccessControl.FileSystemAccessRule("$iisUser", "ReadAndExecute", "Allow")
    $acl.AddAccessRule($rule)
    Set-Acl $filePath $acl

    Write-Host "Add access control at $filePath successfully"

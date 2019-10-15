#################################################
#Add AccessControl at Temp Folder
#---------------------------------------------
 Param
(
    [Parameter(Mandatory=$true)]
    [string]$folder,
    [Parameter(Mandatory=$true)]
    [string]$myGroup 
)

#$myGroup = "IIS_IUSRS"

if (!(Test-Path -Path $folder ))
{
    New-Item $folder -ItemType Directory
    Write-Host "Add log file [ $filePath ] Successfully"
    #------------------
   
}

$acl = Get-Acl $folder
$rule = New-Object System.Security.AccessControl.FileSystemAccessRule("$myGroup", "Modify", "ContainerInherit, ObjectInherit", "None", "Allow")
$acl.AddAccessRule($rule)
$rule = New-Object System.Security.AccessControl.FileSystemAccessRule("$myGroup", "ReadAndExecute", "ContainerInherit, ObjectInherit", "None", "Allow")
$acl.AddAccessRule($rule)
Set-Acl $folder $acl
Write-Host "Add access control at Temp folder successfully"
param(
     [Parameter(Mandatory)]
     [string]$SAPassword
	 
	 [Parameter(Mandatory)]
	 [string]$ContainerName
	 
	 [Parameter(Mandatory)]
	 [string]$Port
 )
 
#generate the restore SQL script file
$RestoreScriptPath= $PSScriptRoot+"\generate-restore-script.ps1"
$RestoreScriptContent = Invoke-Expression "$RestoreScriptPath -databases_file ./databases.json"
$RestoreScriptContent | Set-Content -Path ./restore-dbfiles.sql

#generate the docker file
$dockerContent = (Get-Content ./DockerfileTemplate) -replace '{sa_password}',$SAPassword
New-Item -Path . -Name "Dockerfile" -ItemType "file"
$dockerContent > ./Dockerfile

#run docker commands to build the image

$imageName = "DockerImage_$ContainerName"

docker build -t $imageName . 

docker run -d -p 1433:$Port --name=$ContainerName $imageName
param(
     [Parameter(Mandatory)]
     [string]$SAPassword,
	 
	 [Parameter(Mandatory)]
	 [string]$ContainerName,
	 
	 [Parameter(Mandatory)]
	 [string]$Port
	 
 )
 
$output = $ContainerName
if(!(test-path $output))
{
  mkdir $output
}
$outputDir = (Resolve-Path $output).Path
#generate the restore SQL script file
$RestoreScriptOutputDir = $outputDir
$RestoreScriptOutputPath = Join-Path -Path $RestoreScriptOutputDir -ChildPath "restore-script.sql"
$RestoreScriptGeneratorPath= Join-Path -Path $PSScriptRoot -ChildPath "generate-restore-script.ps1"
$RestoreScriptContent = Invoke-Expression "& `"$RestoreScriptGeneratorPath`" -databases_file ./databases.json"
$RestoreScriptContent | Set-Content -Path $RestoreScriptOutputPath

#generate the docker file
$dockerContent = (Get-Content ./DockerfileTemplate) -replace '{sa_password}',$SAPassword
$outputDockerfile = Join-Path -Path $outputDir -ChildPath "Dockerfile"

New-Item $outputDockerfile -ItemType "file" -Force
$dockerContent > $outputDockerfile

$dbfiles = "databasefiles"
$dbfilesDir = (Resolve-Path "databasefiles").Path
$dbfilesTempOutput = Join-Path -Path $outputDir -ChildPath $dbfiles

echo "$dbfilesDir --> $dbfilesTempOutput"
if (test-path $dbfilesTempOutput){
	remove-item $dbfilesTempOutput -Recurse
}
Copy-Item $dbfilesDir $outputDir -Recurse
Copy-Item "restore.sh" $outputDir

#run docker commands to build the image
$imageName = "dockerimage_$ContainerName"
docker build -t $imageName ./$output/
docker run --rm -d -p 1433:$Port -v $dbfilesDir:/shared_files --name=$ContainerName $imageName
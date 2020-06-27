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

$dbfiles = "databasefiles"
$dbfilesDir = (Resolve-Path "databasefiles").Path
$dbfilesTempOutput = Join-Path -Path $outputDir -ChildPath $dbfiles

echo "$dbfilesDir --> $dbfilesTempOutput"
if (test-path $dbfilesTempOutput){
	remove-item $dbfilesTempOutput -Recurse
}
Copy-Item $dbfilesDir $outputDir -Recurse
docker run -e "ACCEPT_EULA=Y" `
-e "SA_PASSWORD=$SAPassword" `
-p 1433:$Port --name $ContainerName `
-d mcr.microsoft.com/mssql/server:2019-CU3-ubuntu-18.04 `
-v $dbfilesDir`:/shared_files
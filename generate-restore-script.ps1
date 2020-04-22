param(
	[Parameter()]
     [string]$databases_file
)

$jsonObject = Get-Content $databases_file | ConvertFrom-Json
$databases = $jsonObject.databases
$restoreScript = ""
foreach ($db in $databases)
{
	$restoreScript += "create database $($db.name) on(Filename='/databasefiles/$($db.mdfFilename)' LOG on(Filename='/databasefiles/$($db.ldfFilename)' for attach;`n"
}

return $restoreScript
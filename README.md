# Easy-Docker-SQLServer

## What is it?
This tool targets a very specific audience that have wrecked their SQL Server installation on their Windows PC and don't want to fix it. It is basically a Powershell script that will build and create a docker container for you containing all the databases you had in the state they were when you broke you SQL Server instance(s) or installation. 
### Disclaimer
This tool is not meant for production purposes.

## What are the prerequisites?
 - Windows 10 environment (This was never tested on older versions, but be cool and upgrade if you didn't already)
 - Some Docker for Desktop flavor installed on the machine
 - Back-up files for unaccessible databases (.ldf and .mdf files)
 - Powershell 2.0+
 - SSMS 2014 and up

## Getting started
 
 1. Copy and paste the backup files from your deceased SQL Server instance into the "databasefiles" folder;
 2. Specify the structure of your databases by editing the content of the file "databases.json"; The content of the file should have this kind of structure : 
 `{"databases":[
     {
     "name":"<foo_db_name>",
     "ldfFileName":"<foo_ldfFileName>",
     "mdfFileName":"<foo_mdfFileName>"
     }
 ]}`
 
 3. Open Powershell and run
 `PS> Easy-Docker-SQLServer.ps1 -SAPassword "<your_sa_password>" -ContainerName "<your_container_name> -Port "<desired_port>"`. 
 Don't worry, this operation can take a few minutes depending on your network speed.
 4. You now have an SQLServer container ready to be started! Open Powershell and run this command : 
`PS> docker start <your_container_name>`
5. After a short while, the database engine will be ready to be put to work; you can now connect to it using the following address and credentials in SSMS : 
> Address  : localhost,<desired_port>
> username : sa
> password : <your_sa_password>

**Note** : the container will persist its state when stopped, but all the new data added after its creation will be lost if the container is deleted from Docker's workspace, thus you might want to create backups before bringing critical changes to your system.

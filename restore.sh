#!/bin/bash
password="admin"
while [ "$1" != "" ]; do
    case $1 in
        (-p | --password)           
			shift
			password=$1
			;;
		(*) 
			exit
			;;
    esac
    shift
done

/opt/mssql-tools/bin/sqlcmd -S localhost -U SA -P "$password" -i /tmp/restore-dbfiles.sql
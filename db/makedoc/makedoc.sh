#!/bin/sh

dbType=$1

if [ -f "$dbName" ] 
    then java -jar schemaSpy_5.0.0.jar -t $dbType -o ../../untracked/$dbType
else echo no file $dbName
fi




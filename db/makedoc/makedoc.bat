@echo off
set db_type=%1
java -jar schemaSpy_5.0.0.jar -t %* -o ../../untracked/%db_type%
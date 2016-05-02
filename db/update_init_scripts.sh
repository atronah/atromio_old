#!/bin/sh
echo '<!DOCTYPE RCC>
<RCC version="1.0">
    <qresource prefix="/db">' > init_db.qrc

for i in "mysql" "sqlite" 
do
    pushd "$i"
    liquibase updateSQL > ${i}_init.sql
    popd
    echo "        <file>${i}/${i}_init.sql</file>" >> init_db.qrc 
done

echo '    </qresource>
</RCC>' >> init_db.qrc 

#rcc --binary -o init_db.rc init_db.qrc
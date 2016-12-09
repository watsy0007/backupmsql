#!/bin/bash

echo $DB_HOST, $DB_USER, $DB_PASSWORD
databases=`mysql -h $DB_HOST -u $DB_USER -p$DB_PASSWORD -e "SHOW DATABASES;" | tr -d "| " | grep -v Database`

for db in $databases; do
    if [[ "$db" == $BACKUP_DB_NAME ]];  then
        if ls *.`date +%Y%m%d`.$db.sql.gz > /dev/null 2>&1; then
            echo "`date +%Y%m%d`.$db.sql.gz exists"
        else
            echo "Dumping database: $db"
            mysqldump --compact --compress --quick --max_allowed_packet=1024M --single-transaction -h $DB_HOST -u $DB_USER -p$DB_PASSWORD --databases $db > backups/`date +%Y%m%d`.$db.sql
            echo "zip database backup file: $db"
            gzip backups/`date +%Y%m%d`.$db.sql
            echo "Dumping & zip done"
        fi
    fi
done

exit 0

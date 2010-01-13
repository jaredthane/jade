#!/bin/bash
TIMESTAMP=`date +%m%d%Y`
# edit the following 6 lines
BACKUP_FOLDER=/srv/jade/public/backup
MYSQL_USER=root
MYSQL_PASSWORD=YOURMYSQLPASSWORD
DBNAME=Jade
MYSQL_HOST=localhost

# don't edit this line
/usr/bin/mysqldump -h$MYSQL_HOST -q -u$MYSQL_USER -p$MYSQL_PASSWORD $DBNAME | gzip > $BACKUP_FOLDER/$DBNAME-$TIMESTAMP.sql.gz 

# Use this cron tab entry:
# 5 1 * * * /srv/jade/backup.sh 

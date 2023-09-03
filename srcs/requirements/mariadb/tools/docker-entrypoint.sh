#!/bin/sh

mysql_install_db
/etc/init.d/mysql start

#Check if the database exists

if [ ! -d "/var/lib/mysql/$MYSQL_DB_NAME" ]; then

# Set root option so that connexion without root password is not possible
mysql_secure_installation << _EOF_

Y
root4life
root4life
Y
n
Y
Y
_EOF_

#Add a root user on 127.0.0.1 to allow remote connexion
#Flush privileges allow to your sql tables to be updated automatically when you modify it
#mysql -uroot launch mysql command line client
echo "GRANT ALL ON *.* TO 'root'@'%' IDENTIFIED BY '$MYSQL_ROOT_PASS'; FLUSH PRIVILEGES;" | mysql -uroot

#Create database and user in the database for wordpress
echo "CREATE DATABASE IF NOT EXISTS $MYSQL_DB_NAME; GRANT ALL ON $MYSQL_DB_NAME.* TO '$MYSQL_USER'@'%' IDENTIFIED BY '$MYSQL_USER_PASS'; FLUSH PRIVILEGES;" | mysql -u root

#Import database in the mysql command line
mysql -uroot -p$MYSQL_ROOT_PASS $MYSQL_DB_NAME < db-config.sql

fi

/etc/init.d/mysql stop

exec "$@"

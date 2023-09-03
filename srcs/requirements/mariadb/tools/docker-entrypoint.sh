#!/bin/sh

# DATABASE_PATH=/var/lib/mysqld/$MYSQL_DB_NAME

# if [ ! -d "$DATABASE_PATH" ]; then
# 	service mysql start;
# 	mysql -u root --execute= \
# 		"CREATE DATABASE IF NOT EXISTS $MYSQL_DB_NAME; \
# 		GRANT ALL ON $MYSQL_DB_NAME.* TO '$MYSQL_USER'@'%' IDENTIFIED BY '$MYSQL_PASSWORD' WITH GRANT OPTION;; \
# 		ALTER USER 'root'@'localhost' IDENTIFIED BY '$MYSQL_ROOT_PASS'; \
# 		FLUSH PRIVILEGES;"
# 	# mysql -uroot -p$MYSQL_ROOT_PASS $MYSQL_DB_NAME < db-config.sql ;
# 	mysqladmin -uroot -p$MYSQL_ROOT_PASS shutdown;
# fi

# mysql_install_db

if [ ! -d "/var/lib/mysql/$MYSQL_DB_NAME" ]; then

mysql_install_db
service mariadb start

mysql_secure_installation << EOF

y
$MYSQL_ROOT_PASS
$MYSQL_ROOT_PASS
y
n
y
y
EOF

mariadb -u mysql -p $MYSQL_ROOT_PASS $MYSQL_DB_NAME < db-config.sql

fi

# /etc/init.d/mysql stop
service mariadb stop

exec "$@"
# mysqld --user=mysql --init-file=/db-config.sql

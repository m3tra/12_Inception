#!/bin/sh

DATABASE_PATH=/var/lib/mysql/$MYSQL_DATABASE

if [ ! -d "$DATABASE_PATH" ] then
	service mysql start;
	mysql -u root --execute= \
		"CREATE DATABASE IF NOT EXISTS $MYSQL_DATABASE; \
		GRANT ALL ON $MYSQL_DATABASE.* TO '$MYSQL_USER'@'%' IDENTIFIED BY '$MYSQL_PASSWORD' WITH GRANT OPTION;; \
		ALTER USER 'root'@'localhost' IDENTIFIED BY '$MYSQL_ROOT_PASSWORD'; \
		FLUSH PRIVILEGES;"
	# mysql -uroot -p$MYSQL_ROOT_PASSWORD $MYSQL_DATABASE < wordpress.sql ;
	mysqladmin -uroot -p$MYSQL_ROOT_PASSWORD shutdown;
fi

# exec "$@"

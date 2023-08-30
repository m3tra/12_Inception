#!/bin/sh

# DATABASE_PATH=/var/lib/mysqld/$MYSQL_DATABASE

# if [ ! -d "$DATABASE_PATH" ]; then
# 	service mysql start;
# 	mysql -u root --execute= \
# 		"CREATE DATABASE IF NOT EXISTS $MYSQL_DATABASE; \
# 		GRANT ALL ON $MYSQL_DATABASE.* TO '$MYSQL_USER'@'%' IDENTIFIED BY '$MYSQL_PASSWORD' WITH GRANT OPTION;; \
# 		ALTER USER 'root'@'localhost' IDENTIFIED BY '$MYSQL_ROOT_PASSWORD'; \
# 		FLUSH PRIVILEGES;"
# 	# mysql -uroot -p$MYSQL_ROOT_PASSWORD $MYSQL_DATABASE < db-config.sql ;
# 	mysqladmin -uroot -p$MYSQL_ROOT_PASSWORD shutdown;
# fi

# mysql_install_db

if [ ! -d "/var/lib/mysql/$MYSQL_DATABASE" ]; then

mysql_install_db
service mariadb start

# mysql_secure_installation << EOF

# y
# $MYSQL_ROOT_PASSWORD
# $MYSQL_ROOT_PASSWORD
# y
# n
# y
# y
# EOF

echo "GRANT ALL ON *.* TO 'root'@'%' IDENTIFIED BY '$MYSQL_ROOT_PASSWORD'; FLUSH PRIVILEGES;" | mysql -uroot

echo "\
CREATE DATABASE IF NOT EXISTS $MYSQL_DATABASE; \
GRANT ALL ON $MYSQL_DATABASE.* TO '$MYSQL_USER'@'%' IDENTIFIED BY '$MYSQL_PASSWORD'; \
FLUSH PRIVILEGES;" | mariadb -u root

mariadb -u root -p $MYSQL_ROOT_PASSWORD $MYSQL_DATABASE < wordpress2.sql

fi

# /etc/init.d/mysql stop
# service mariadb stop

exec "$@"

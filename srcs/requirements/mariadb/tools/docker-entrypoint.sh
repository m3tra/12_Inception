#!/bin/sh

# mkdir -p /var/lib/mysql
# chmod -R 777 /var/lib/mysql
# chown -R mysql:mysql /var/lib/mysql

mysql_install_db
service mariadb start

if [ ! -d "/var/lib/mysql/$MYSQL_DB_NAME" ]; then

mysql_secure_installation << EOF
$MYSQL_ROOT_PASS
y
n
y
y
y
y
EOF

fi

service mariadb stop

mysqld --user=mysql --init-file=/db-config.sql --bind-address=0.0.0.0
# exec "$@"

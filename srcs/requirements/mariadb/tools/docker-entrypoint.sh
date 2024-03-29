#!/bin/bash

mysql_install_db --user=mysql --datadir=/var/lib/mysql

service mariadb start

if [ ! -d "/var/lib/mysql/$WP_DB_NAME" ]; then
mysql_secure_installation << EOF
$ADMIN_PASS
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

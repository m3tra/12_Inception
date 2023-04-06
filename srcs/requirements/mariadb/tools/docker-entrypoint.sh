#!/bin/sh
set -e

sed -i s/'{$WP_DB_NAME}'/$WP_DB_NAME/g /tmp/db-config.sql
sed -i s/'{$WP_ADMIN}'/$WP_ADMIN/g /tmp/db-config.sql
sed -i s/'{$WP_ADMIN_PASSWORD}'/$WP_ADMIN_PASSWORD/g /tmp/db-config.sql
sed -i s/'{$WP_ADMIN_PASSWORD}'/$WP_ADMIN_PASSWORD/g /etc/mysql/debian.cnf

service mysql start
mariadb -p$WP_ADMIN_PASSWORD < /tmp/db-config.sql && sleep 1
service mysql stop

echo "*****Starting MariaDB Container*****"

exec "$@"

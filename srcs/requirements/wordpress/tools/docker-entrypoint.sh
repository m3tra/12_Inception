#!/bin/bash

if [ ! -f /var/www/html/wp-config-sample.php ]; then
mkdir /run/php
wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
chmod +x wp-cli.phar
mv wp-cli.phar /usr/local/bin/wp.phar

wp.phar core download \
	--path=/var/www/html \
	--allow-root

wp.phar config create \
	--path=/var/www/html \
	--dbhost=$MYSQL_HOSTNAME \
	--dbname=$MYSQL_DB_NAME \
	--dbuser=$MYSQL_USER \
	--dbpass=$MYSQL_PASS \
	--allow-root

wp.phar db create \
	--path=/var/www/html \
	--allow-root

wp.phar core install \
	--path=/var/www/html \
	--url=$DOMAIN_NAME \
	--title="$WP_TITLE" \
	--admin_user=$WP_ADMIN \
	--admin_password=$WP_ADMIN_PASS \
	--admin_email=$WP_ADMIN_EMAIL \
	--skip-email \
	--allow-root

wp.phar plugin update \
	--path=/var/www/html \
	--all \
	--allow-root

wp.phar user create \
	--path=/var/www/html \
	$WP_USER \
	$WP_USER_EMAIL \
	--user_pass=$WP_USER_PASSWORD \
	--role=author \
	--allow-root

sed -i 's/listen = \/run\/php\/php7.4-fpm.sock/listen = 9000/g' /etc/php/7.4/fpm/pool.d/www.conf
chown -R www-data:www-data /var/www/html/
fi

exec "$@"
# /usr/sbin/php-fpm7.4 -F

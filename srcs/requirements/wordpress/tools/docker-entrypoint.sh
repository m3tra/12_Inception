#!/bin/bash

if [ ! -f /var/www/html/wp-config-sample.php ]; then
	wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
	chmod +x wp-cli.phar
	mv wp-cli.phar /usr/local/bin/wp.phar

	cd /var/www/html

	wp.phar core download \
		--allow-root

	wp.phar config create \
		--dbhost=$MYSQL_HOSTNAME \
		--dbname=$WP_DB_NAME \
		--dbuser=$ADMIN_USER \
		--dbpass=$ADMIN_PASS \
		--allow-root

	wp.phar db create \
		--allow-root

	wp.phar core install \
		--url=$DOMAIN_NAME \
		--title="$WP_TITLE" \
		--admin_user=$ADMIN_USER \
		--admin_password=$ADMIN_PASS \
		--admin_email=$WP_ADMIN_EMAIL \
		--skip-email \
		--allow-root

	wp.phar theme delete \
		--all \
		--allow-root

	wp.phar plugin uninstall \
		--all \
		--allow-root

	wp.phar config set \
		WP_REDIS_HOST "redis" \
		--allow-root

	wp.phar plugin install \
		redis-cache \
		--activate \
		--allow-root

	wp.phar redis enable \
		--allow-root

	wp.phar user create \
		$WP_USER \
		$WP_USER_EMAIL \
		--user_pass=$WP_USER_PASSWORD \
		--role=author \
		--allow-root

	chown -R www-data:www-data /var/www/html/
fi

sed -i 's/listen = \/run\/php\/php7.4-fpm.sock/listen = 9000/g' /etc/php/7.4/fpm/pool.d/www.conf

/usr/sbin/php-fpm7.4 -F

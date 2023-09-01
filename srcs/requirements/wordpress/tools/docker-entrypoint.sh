#!/bin/bash

# wp core download --allow-root

# wp config create --dbname=$MYSQL_DATABASE --dbuser=$MYSQL_USER --dbpass=$MYSQL_ROOT_PASSWORD --dbhost=mariadb --allow-root

# # wp config set WP_REDIS_HOST redis --allow-root
# # wp config set WP_REDIS_PORT 6379 --raw --allow-root
# # wp config set WP_CACHE_KEY_SALT $DOMAIN_NAME --allow-root
# # wp config set WP_CACHE true --raw --allow-root

# wp core install --url=$DOMAIN_NAME --title="$WP_TITLE" --admin_user=$MYSQL_USER --admin_password=$MYSQL_ROOT_PASSWORD --admin_email=$WORDPRESS_USER_EMAIL --skip-email --allow-root
# wp user create $MYSQL_USER $WORDPRESS_USER_EMAIL --user_pass=$MYSQL_PASSWORD --role=author --allow-root

# # wp plugin install redis-cache --activate --allow-root
# # wp plugin update --all --allow-root
# # wp redis enable --allow-root

# chown -R www-data:www-data /var/www/html/wordpress

set -e

# # waiting for mariadb
# while ! mariadb -hmariadb -u$MYSQL_USER -p$MYSQL_ROOT_PASSWORD $MYSQL_DATABASE > /dev/null 2>&1; do
# 	echo "Waiting for MariaDB ..."
# 	sleep 2
# done

# # waiting for redis
# while ! redis-cli -h redis > /dev/null 2>&1; do
# 	echo "Waiting for Redis ..."
# 	sleep 2
# done

# mkdir -p /var/www/html

# if [ ! -d "wordpress" ]; then
# 	echo "no folder"
# 	wget https://wordpress.org/latest.tar.gz
# 	tar -xzvf latest.tar.gz
# 	rm -r latest.tar.gz
# fi

# cd /var/www/html/wordpress

# if [ ! -f /var/www/html/wordpress/index.php ]; then
# 	wp core download --allow-root
# fi

# if [ ! -f /var/www/html/wordpress/wp-config.php ]; then
# 	wp config create \
# 		--dbname=$MYSQL_DATABASE \
# 		--dbuser=$MYSQL_USER \
# 		--dbpass=$MYSQL_ROOT_PASSWORD \
# 		--dbhost=mariadb \
# 		--allow-root
# 	# wp config set WP_REDIS_HOST redis --allow-root
# 	# wp config set WP_REDIS_PORT 6379 --raw --allow-root
# 	# wp config set WP_CACHE_KEY_SALT $DOMAIN_NAME --allow-root
# 	# wp config set WP_CACHE true --raw --allow-root

# 	wp core install \
# 		--url=$DOMAIN_NAME \
# 		--title="$WP_TITLE" \
# 		--admin_user=$MYSQL_USER \
# 		--admin_password=$MYSQL_USER_PASSWORD \
# 		--admin_email=$WP_ADMIN_EMAIL \
# 		--skip-email \
# 		--allow-root

# 	wp user create \
# 		$WP_USER \
# 		$WP_USER_EMAIL \
# 		--user_pass=$WP_USER_PASSWORD \
# 		--role=author \
# 		--allow-root

# 	# wp plugin install redis-cache --activate --allow-root
# 	# wp plugin update --all --allow-root
# 	# wp redis enable --allow-root

# 	chown -R www-data:www-data /var/www/html/wordpress
# fi

# create the PID file(/run/php/php7.4-fpm.pid)
# service php7.4-fpm start
# service php7.4-fpm stop

# echo "*****Starting Wordpress Container*****"



if [ ! -f /usr/local/bin/wp.phar ]; then

wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
chmod +x wp-cli.phar
mv wp-cli.phar /usr/local/bin/wp.phar

wp.phar core download \
	--allow-root

wp.phar config create \
	--dbname=$MYSQL_DATABASE \
	--dbuser=$MYSQL_USER \
	--dbpass=$MYSQL_ROOT_PASSWORD \
	--dbhost=$MYSQL_HOSTNAME \
	--allow-root

wp.phar db create \
	--allow-root

wp.phar core install \
	--url=$DOMAIN_NAME \
	--title="$WP_TITLE" \
	--admin_user=$MYSQL_USER \
	--admin_password=$MYSQL_USER_PASSWORD \
	--admin_email=$WP_ADMIN_EMAIL \
	--skip-email \
	--allow-root

# wp.phar core update \
# 	--allow-root

wp.phar plugin update --all \
	--allow-root

wp.phar user create \
	$WP_USER \
	$WP_USER_EMAIL \
	--user_pass=$WP_USER_PASSWORD \
	--role=author \
	--allow-root

fi

# exec "$@"
/usr/sbin/php-fpm7.4 -F

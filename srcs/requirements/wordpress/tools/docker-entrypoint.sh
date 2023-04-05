# #!/bin/bash

# wp core download --allow-root

# wp config create --dbname=$WP_DB_NAME --dbuser=$WP_ADMIN --dbpass=$WP_ADMIN_PASSWORD --dbhost=mariadb --allow-root

# # wp config set WP_REDIS_HOST redis --allow-root
# # wp config set WP_REDIS_PORT 6379 --raw --allow-root
# # wp config set WP_CACHE_KEY_SALT $DOMAIN_NAME --allow-root
# # wp config set WP_CACHE true --raw --allow-root

# wp core install --url=$DOMAIN_NAME --title="$WP_TITLE" --admin_user=$WP_ADMIN --admin_password=$WP_ADMIN_PASSWORD --admin_email=$WP_ADMIN_EMAIL --skip-email --allow-root
# wp user create $WP_USER $WP_USER_EMAIL --user_pass=$WP_USER_PASSWORD --role=author --allow-root

# # wp plugin install redis-cache --activate --allow-root
# # wp plugin update --all --allow-root
# # wp redis enable --allow-root

# chown -R www-data:www-data /var/www/html/wordpress

#!/bin/bash
set -e

# waiting for mariadb
while ! mariadb -hmariadb -u$WP_ADMIN -p$WP_ADMIN_PASSWORD $WP_DB_NAME > /dev/null 2>&1; do
	echo "Waiting for MariaDB ..."
	sleep 2
done

# # waiting for redis
# while ! redis-cli -h redis > /dev/null 2>&1; do
# 	echo "Waiting for Redis ..."
# 	sleep 2
# done

cd /var/www/html/wordpress

if [ ! -f /var/www/html/wordpress/index.php ]; then
	wp core download --allow-root
fi

if [ ! -f /var/www/html/wordpress/wp-config.php ]; then
	wp config create --dbname=$WP_DB_NAME --dbuser=$WP_ADMIN --dbpass=$WP_ADMIN_PASSWORD --dbhost=mariadb --allow-root
	# wp config set WP_REDIS_HOST redis --allow-root
	# wp config set WP_REDIS_PORT 6379 --raw --allow-root
	# wp config set WP_CACHE_KEY_SALT $DOMAIN_NAME --allow-root
	# wp config set WP_CACHE true --raw --allow-root

	wp core install --url=$DOMAIN_NAME --title="$WP_TITLE" --admin_user=$WP_ADMIN --admin_password=$WP_ADMIN_PASSWORD --admin_email=$WP_ADMIN_EMAIL --skip-email --allow-root
	wp user create $WP_USER $WP_USER_EMAIL --user_pass=$WP_USER_PASSWORD --role=author --allow-root

	# wp plugin install redis-cache --activate --allow-root
	# wp plugin update --all --allow-root
	# wp redis enable --allow-root

	chown -R www-data:www-data /var/www/html/wordpress
fi

# create the PID file(/run/php/php8.1-fpm.pid)
service php8.1-fpm start
service php8.1-fpm stop

echo "*****Starting Wordpress Container*****"

exec "$@"

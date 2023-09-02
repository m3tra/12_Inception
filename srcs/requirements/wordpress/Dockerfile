FROM debian:bullseye

RUN apt-get update
RUN apt-get install -y \
		wget \
		php7.4 \
		php7.4-cli \
		php7.4-fpm \
		php7.4-mysql \
		php7.4-json \
		php7.4-opcache \
		php7.4-mbstring \
		php7.4-xml \
		php7.4-gd \
		php7.4-curl \
		mariadb-client

# RUN wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
# &&	chmod +x wp-cli.phar \
# &&	mv wp-cli.phar /usr/local/bin/wp \
# &&	wp core download \
# 		--allow-root \
# &&	wp config create \
# 		--dbname=$MYSQL_DB_NAME \
# 		--dbuser=$MYSQL_USER \
# 		--dbpass=$MYSQL_ROOT_PASSWORD \
# 		--dbhost=$MYSQL_HOSTNAME \
# 		--allow-root \
# &&	wp db create \
# 		--allow-root\
# &&	wp core install \
# 		--url=$DOMAIN_NAME \
# 		--title="$WP_TITLE" \
# 		--admin_user=$MYSQL_USER \
# 		--admin_password=$MYSQL_USER_PASSWORD \
# 		--admin_email=$WP_ADMIN_EMAIL \
# 		--skip-email \
# 		--allow-root \
# &&	wp core update \
# 		--allow-root \
# &&	wp plugin update --all \
# 		--allow-root \
# &&	wp user create \
# 		$WP_USER \
# 		$WP_USER_EMAIL \
# 		--user_pass=$WP_USER_PASSWORD \
# 		--role=author \
# 		--allow-root

# RUN mkdir -p /var/www/html

# WORKDIR /var/www/html

# Download, extract and install wordpress
# RUN wget https://wordpress.org/latest.tar.gz \
# &&	tar -xzvf latest.tar.gz \
# &&	rm -r latest.tar.gz

# COPY conf/wp-config.php ./wordpress/




# RUN mkdir /run/php

EXPOSE 9000

# COPY tools/docker-entrypoint.sh /
# RUN chmod +x /docker-entrypoint.sh
# ENTRYPOINT ["/docker-entrypoint.sh"]

# CMD ["/usr/sbin/php-fpm7.4", "-F"]
CMD ["tail", "-f", "/dev/null"]

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

ARG ADMIN_USER
ARG ADMIN_PASS

ARG DOMAIN_NAME

ARG MYSQL_HOSTNAME
ARG MYSQL_DB_NAME
ARG MYSQL_USER
ARG MYSQL_PASS

ARG WP_TITLE
ARG WP_ADMIN_EMAIL
ARG WP_USER
ARG WP_USER_PASSWORD
ARG WP_USER_EMAIL

RUN wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
&&	chmod +x wp-cli.phar \
&&	mv wp-cli.phar /usr/local/bin/wp.phar

RUN mkdir -p /var/www/html \
&&	chown www-data:www-data /var/www/html/
RUN mkdir /run/php

RUN wp.phar core download \
		--path=/var/www/html \
		--allow-root

RUN wp.phar config create \
		--path=/var/www/html \
		--allow-root \
		--dbhost=$MYSQL_HOSTNAME \
		--dbname=$MYSQL_DB_NAME \
		--dbuser=$MYSQL_USER \
		--dbpass=$MYSQL_PASS

RUN wp.phar db create \
		--path=/var/www/html \
		--allow-root

RUN wp.phar core install \
		--path=/var/www/html \
		--allow-root \
		--url=$DOMAIN_NAME \
		--title="$WP_TITLE" \
		--admin_user=$ADMIN_USER \
		--admin_password=$ADMIN_PASS \
		--admin_email=$WP_ADMIN_EMAIL \
		--skip-email

RUN wp.phar plugin update \
		--path=/var/www/html \
		--allow-root \
		--all

RUN wp.phar user create \
		--path=/var/www/html \
		--allow-root \
		$WP_USER \
		$WP_USER_EMAIL \
		--user_pass=$WP_USER_PASSWORD \
		--role=author

RUN sed -i 's/listen = \/run\/php\/php7.4-fpm.sock/listen = 9000/g' /etc/php/7.4/fpm/pool.d/www.conf

EXPOSE 9000

# COPY tools/docker-entrypoint.sh /
# RUN chmod +x /docker-entrypoint.sh
# ENTRYPOINT ["/docker-entrypoint.sh"]

CMD ["/usr/sbin/php-fpm7.4", "-F"]
# CMD ["tail", "-f", "/dev/null"]

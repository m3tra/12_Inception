FROM debian:bullseye-slim

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
		mariadb-client \
&&	apt-get clean \
&&	rm -rf /var/lib/apt/lists/* /var/tmp/* /tmp/*

RUN mkdir /run/php

EXPOSE 9000

COPY tools/docker-entrypoint.sh /
RUN chmod +x /docker-entrypoint.sh
ENTRYPOINT ["/docker-entrypoint.sh"]

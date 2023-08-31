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
		php7.4-curl

RUN mkdir -p /var/www/html

WORKDIR /var/www/html

# Download, extract and install wordpress
# RUN wget https://wordpress.org/latest.tar.gz \
# &&	tar -xzvf latest.tar.gz \
# &&	rm -r latest.tar.gz

EXPOSE 9000

# COPY tools/docker-entrypoint.sh /
# RUN chmod +x /docker-entrypoint.sh
# ENTRYPOINT ["/docker-entrypoint.sh"]

# CMD ["php-fpm"]
CMD ["tail", "-f", "/dev/null"]

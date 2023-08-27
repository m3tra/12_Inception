FROM debian:bullseye

RUN apt-get update \
	&& apt-get install -y \
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

# Download, extract and install wordpress
RUN wget https://wordpress.org/latest.tar.gz \
	&& tar -xzvf latest.tar.gz \
	&& rm -r latest.tar.gz
# RUN mv wordpress /

# Generate ssl certificate for https
RUN mkdir -p /etc/nginx/ssl/ \
	&& openssl req -newkey rsa:4096 -x509 -sha256 -days 365 -nodes \
		-out /etc/nginx/ssl/server.crt \
		-keyout /etc/nginx/ssl/server.key \
		-subj "/C=/ST=/L=/O=/OU=/CN=/"

EXPOSE 9000

COPY tools/docker-entrypoint.sh /
RUN chmod +x /docker-entrypoint.sh
ENTRYPOINT ["/docker-entrypoint.sh"]

CMD ["php-fpm"]

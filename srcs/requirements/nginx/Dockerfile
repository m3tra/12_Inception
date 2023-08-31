# # Get secure ciphers config
# RUN mkdir -p conf \
# &&	curl -sSLo ./conf/options-ssl-nginx.conf https://raw.githubusercontent.com/certbot/certbot/master/certbot-nginx/certbot_nginx/_internal/tls_configs/options-ssl-nginx.conf

# # Copy configs to service's directory
# COPY conf/nginx.conf /etc/nginx/conf.d/

FROM debian:bullseye

RUN apt-get update
RUN	apt-get install -y \
		nginx \
		openssl


# FROM alpine:3.17

# RUN apk add --no-cache \
# 		nginx \
# 		openssl

# nginx SSL
RUN mkdir -m 777 -p /etc/nginx/ssl \
&&	openssl req -newkey rsa:4096 -x509 -sha256 -days 365 -nodes \
		-out /etc/nginx/ssl/server.crt \
		-keyout /etc/nginx/ssl/server.key \
		-subj "/C=/ST=/L=/O=/OU=/CN=/"

COPY conf/nginx.conf /etc/nginx/conf.d

# nginx config
RUN mkdir -p /run/nginx

#the only port allowed
EXPOSE 443

# Start nginx
CMD ["nginx", "-g", "daemon off;"]

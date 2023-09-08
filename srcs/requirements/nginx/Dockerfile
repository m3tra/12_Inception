FROM debian:bullseye

RUN apt-get update
RUN	apt-get install -y \
		nginx \
		openssl

RUN mkdir -m 777 -p /etc/nginx/ssl \
&&	openssl req \
		-newkey rsa:4096 \
		-x509 \
		-sha256 \
		-days 365 \
		-nodes \
		-out /etc/nginx/ssl/server.crt \
		-keyout /etc/nginx/ssl/server.key \
		-subj "/C=/ST=/L=/O=/OU=/CN=/" \
\
&&	mkdir -p /run/nginx \
\
&&	sed -i 's/# server_tokens/server_tokens/g' /etc/nginx/nginx.conf \
\
&&	mkdir -p /etc/nginx/sites-available/ \
&&	rm /etc/nginx/sites-available/default
COPY ./conf/default /etc/nginx/sites-available/

EXPOSE 443

CMD ["nginx", "-g", "daemon off;"]

FROM debian:bullseye-slim

ARG DOMAIN_NAME
ARG ADMIN_USER

RUN apt-get update
RUN	apt-get install -y --no-install-recommends \
		nginx \
		openssl \
&&	apt-get clean \
&&	rm -rf /var/lib/apt/lists/* /var/tmp/* /tmp/*

RUN mkdir /run/nginx \
\
&&	sed -i 's/# server_tokens/server_tokens/g' /etc/nginx/nginx.conf \
\
&&	rm /etc/nginx/sites-available/default
COPY ./conf/default /etc/nginx/sites-available/
RUN sed -e "s/DOMAIN_NAME/$DOMAIN_NAME/g" \
		-e "s/ADMIN_USER/$ADMIN_USER/g" \
		-i /etc/nginx/sites-available/default

EXPOSE 443

COPY tools/docker_entrypoint.sh /
RUN chmod +x /docker_entrypoint.sh
ENTRYPOINT ["/docker_entrypoint.sh"]

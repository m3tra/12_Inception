FROM debian:bullseye-slim

RUN apt-get update
RUN apt-get install -y --no-install-recommends \
		mariadb-server \
&&	apt-get clean \
&&	rm -rf /var/lib/apt/lists/* /var/tmp/* /tmp/*

ARG WP_DB_NAME
ARG ADMIN_USER
ARG ADMIN_PASS

COPY conf/db-config.sql /
RUN chmod 444 /db-config.sql \
&&	sed -e "s/WP_DB_NAME/$WP_DB_NAME/g" \
		-e "s/ADMIN_USER/$ADMIN_USER/g" \
		-e "s/ADMIN_PASS/$ADMIN_PASS/g" \
		-i /db-config.sql \
\
&&	mkdir -m 777 /run/mysqld \
&&	chown mysql:mysql /run/mysqld

EXPOSE 3306

COPY tools/docker-entrypoint.sh /
RUN chmod +x /docker-entrypoint.sh
ENTRYPOINT ["/docker-entrypoint.sh"]

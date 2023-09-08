FROM debian:bullseye

RUN apt-get update
RUN apt-get install -y \
		mariadb-server

ARG WP_DB_NAME
ARG ADMIN_USER
ARG ADMIN_PASS

COPY conf/db-config.sql /
RUN chmod 777 /db-config.sql \
&&	sed -i "s/WP_DB_NAME/$WP_DB_NAME/g" /db-config.sql \
&&	sed -i "s/ADMIN_USER/$ADMIN_USER/g" /db-config.sql \
&&	sed -i "s/ADMIN_PASS/$ADMIN_PASS/g" /db-config.sql \
\
&&	mkdir -p -m 777 /var/lib/mysql \
&&	chown -R $ADMIN_USER:$ADMIN_USER /var/lib/mysql \
\
&&	mkdir -p -m 777 /run/mysqld \
&&	chown -R $ADMIN_USER:$ADMIN_USER /run/mysqld

EXPOSE 3306

COPY tools/docker-entrypoint.sh /
RUN chmod +x /docker-entrypoint.sh
ENTRYPOINT ["/docker-entrypoint.sh"]

# CMD ["tail", "-f", "/dev/null"]

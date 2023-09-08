FROM debian:bullseye

RUN apt-get update
RUN apt-get install -y \
		mariadb-server

ARG MYSQL_DB_NAME
ARG MYSQL_USER
ARG MYSQL_PASS

RUN mkdir -p -m 777 /var/lib/mysql \
&&	chown -R $MYSQL_USER:$MYSQL_USER /var/lib/mysql \
\
&&	mkdir -p -m 777 /run/mysqld \
&&	chown -R $MYSQL_USER:$MYSQL_USER /run/mysqld

COPY conf/db-config.sql /
RUN chmod 777 /db-config.sql \
&&	chown $MYSQL_USER:$MYSQL_USER /db-config.sql \
&&	sed -i "s/MYSQL_DB_NAME/$MYSQL_DB_NAME/g" /db-config.sql \
&&	sed -i "s/MYSQL_USER/$MYSQL_USER/g" /db-config.sql \
&&	sed -i "s/MYSQL_PASS/$MYSQL_PASS/g" /db-config.sql

COPY tools/docker-entrypoint.sh /
RUN chmod +x /docker-entrypoint.sh

EXPOSE 3306

ENTRYPOINT ["/docker-entrypoint.sh"]

# CMD ["tail", "-f", "/dev/null"]

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
&&	mkdir -m 777 -p /run/mysqld \
&&	chown mysql:mysql /run/mysqld

RUN	mkdir -m 777 -p /var/lib/mysql \
&&	chown mysql:mysql /var/lib/mysql

RUN	mysql_install_db --user=mysql

EXPOSE 3306

# COPY tools/docker-entrypoint.sh /
# RUN chmod +x /docker-entrypoint.sh
# ENTRYPOINT ["/docker-entrypoint.sh"]

# CMD ["mysqld", "--user=mysql", "--init-file=/db-config.sql", "--bind-address=0.0.0.0"]
CMD ["tail", "-f", "/dev/null"]

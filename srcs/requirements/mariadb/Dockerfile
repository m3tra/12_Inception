FROM debian:bullseye

RUN apt-get update
RUN apt-get install -y \
		mariadb-server \
		nano #TODO remove

# FROM alpine:3.17

# RUN	apk update \
# &&	apk upgrade \
# &&	apk add --no-cache \
# 		mariadb \
# 		mariadb-client

RUN mkdir -p /var/lib/mysql \
&&	chmod -R 777 /var/lib/mysql \
&&	chown -R mysql:mysql /var/lib/mysql

RUN mkdir -p /run/mysqld \
&&	chmod 777 /run/mysqld \
&&	chown -R mysql:mysql /run/mysqld




# RUN mysql_install_db --user=mysql --datadir=/var/lib/mysql

# COPY conf/50-server.cnf /etc/mysql/mariadb.conf.d/
# COPY conf/db-config.sql /
# COPY conf/debian.cnf /etc/mysql/
# RUN chmod 777 /db-config.sql \
# &&	chown mysql:mysql /db-config.sql \
# &&	sed -i "s/MYSQL_DB_NAME/{$MYSQL_DB_NAME}/g" /db-config.sql \
# &&	sed -i "s/MYSQL_USER/{$MYSQL_USER}/g" /db-config.sql \
# &&	sed -i "s/MYSQL_PASS/{$MYSQL_PASS}/g" /db-config.sql \
# &&	sed -i "s/MYSQL_ROOT_PASS/{$MYSQL_ROOT_PASS}/g" /db-config.sql
# COPY conf/wordpress2.sql /





# RUN service mysql start
# RUN mkdir -p /run/mysqld/ \
# &&	chown -R mysql:mysql /run/mysqld
# RUN touch /run/mysqld/mysqld.sock

# RUN mysql_install_db
# && service mariadb stop



COPY conf/db-config.sql /
RUN chmod 777 /db-config.sql \
&&	chown mysql:mysql /db-config.sql \
&&	sed -i "s/MYSQL_DB_NAME/{$MYSQL_DB_NAME}/g" /db-config.sql \
&&	sed -i "s/MYSQL_USER/{$MYSQL_USER}/g" /db-config.sql \
&&	sed -i "s/MYSQL_PASS/{$MYSQL_PASS}/g" /db-config.sql \
&&	sed -i "s/MYSQL_ROOT_PASS/{$MYSQL_ROOT_PASS}/g" /db-config.sql

COPY tools/docker-entrypoint.sh /
RUN chmod +x /docker-entrypoint.sh

EXPOSE 3306

ENTRYPOINT ["/docker-entrypoint.sh"]

# ENTRYPOINT ["/usr/bin/dumb-init", "/tmp/docker-entrypoint.sh"]
# ENTRYPOINT ["mysqld", "--user=mysql", "--init-file=/tmp/db-config.sql"]

# CMD ["mysqld", "--bind-address=0.0.0.0"]

# CMD ["tail", "-f", "/dev/null"]
# CMD ["mysqld", "--user=mysql", "--init-file=/db-config.sql"]

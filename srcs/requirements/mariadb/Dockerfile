FROM debian:bullseye

RUN apt-get update
RUN apt-get install -y \
		mariadb-server

# FROM alpine:3.17

# RUN	apk update \
# &&	apk upgrade \
# &&	apk add --no-cache \
# 		mariadb \
# 		mariadb-client


RUN mysql_install_db --user=mysql

COPY conf/50-server.cnf /etc/mysql/mariadb.cnf.d/
# COPY conf/debian.cnf /etc/mysql/
COPY conf/db-config.sql /tmp
RUN chown mysql:mysql /tmp/db-config.sql \
&&	sed -i "s/MYSQL_DB_NAME/{$MYSQL_DB_NAME}/g" /tmp/db-config.sql \
&&	sed -i "s/MYSQL_USER/{$MYSQL_USER}/g" /tmp/db-config.sql \
&&	sed -i "s/MYSQL_USER_PASS/{$MYSQL_USER_PASS}/g" /tmp/db-config.sql \
&&	sed -i "s/MYSQL_ROOT_PASS/{$MYSQL_ROOT_PASS}/g" /tmp/db-config.sql
# COPY conf/wordpress2.sql /

# RUN chmod -R 777 /var/lib/mysql \
# &&	chown -R mysql:mysql /var/lib/mysql

RUN mkdir -p /run/mysqld \
&&	chmod -R 777 /run/mysqld \
&&	chown -R mysql:mysql /run/mysqld

# RUN service mysql start
# RUN mkdir -p /run/mysqld/ \
# &&	chown -R mysql:mysql /run/mysqld
# RUN touch /run/mysqld/mysqld.sock

# RUN mysql_install_db
# && service mariadb stop


EXPOSE 3306

# COPY tools/docker-entrypoint.sh /
# RUN chmod +x /docker-entrypoint.sh
# ENTRYPOINT ["/usr/bin/dumb-init", "/tmp/docker-entrypoint.sh"]
# ENTRYPOINT ["/docker-entrypoint.sh"]
# ENTRYPOINT ["mysqld", "--user=mysql", "--init-file=/tmp/db-config.sql"]

CMD ["mysqld", "--user=mysql", "--init-file=/tmp/db-config.sql"]
# CMD ["mysqld"]

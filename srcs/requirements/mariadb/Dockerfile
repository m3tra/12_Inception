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

EXPOSE 3306

COPY ./conf/50-server.conf /etc/mysql/mariadb.conf.d/
COPY ./conf/debian.conf /etc/mysql/
COPY ./conf/db-config.sql /
COPY ./conf/wordpress2.sql /usr/local/bin/

# RUN chmod -R 777 /var/lib/mysql \
# &&	chown -R mysql:mysql /var/lib/mysql \
# &&	chgrp -R mysql /var/lib/mysql

RUN mkdir -p /var/run/mysqld \
&&	chmod -R 777 /var/run/mysqld \
&&	chown -R mysql:mysql /var/run/mysqld

# RUN service mysql start
# RUN mkdir -p /run/mysqld/ \
# &&	chown -R mysql:mysql /run/mysqld
# RUN touch /run/mysqld/mysqld.sock

RUN service mariadb start \
&&	mysql_install_db

COPY tools/docker-entrypoint.sh /
RUN chmod +x /docker-entrypoint.sh

# ENTRYPOINT [ "/usr/bin/dumb-init", "/tmp/docker-entrypoint.sh" ]
ENTRYPOINT [ "/docker-entrypoint.sh"]
# ENTRYPOINT ["mysqld", "--user=mysql", "--init-file=/tmp/db-config.sql"]

# CMD [ "mysqld", "--user=mysql" ]
CMD ["mysqld", "--bind-address=0.0.0.0"]

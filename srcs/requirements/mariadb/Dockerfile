FROM debian:bullseye

RUN apt-get update && \
	apt-get install -y \
		mariadb-server

RUN apt-get purge -y mysql-server mysql-common && \
	apt-get purge -y mysql-client && \
	apt-get autoremove -y mysql-server mysql-client mysql-common && \
	apt-get autoclean -y mysql-server mysql-client mysql-common && \
	apt-get install -y mysql-server mysql-common mysql-client

EXPOSE 3306

COPY ./conf/50-server.cnf /etc/mysql/mariadb.conf.d/
COPY ./conf/debian.cnf /etc/mysql/
COPY ./conf/db-config.sql /tmp/

RUN chmod -R 770 /var/lib/mysql && \
	chgrp -R mysql /var/lib/mysql

# RUN service mysql start
RUN mkdir -p /run/mysqld/
RUN touch /run/mysqld/mysqld.sock

COPY tools/docker-entrypoint.sh /
RUN chmod +x /docker-entrypoint.sh

# ENTRYPOINT [ "/usr/bin/dumb-init", "/tmp/docker-entrypoint.sh" ]
ENTRYPOINT [ "/docker-entrypoint.sh" , "mysqld", "--user=mysql"]
# ENTRYPOINT ["mysqld", "--user=mysql", "--init-file=/tmp/db-config.sql"]

# CMD [ "mysqld", "--user=mysql" ]

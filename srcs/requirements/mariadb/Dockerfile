FROM debian:bullseye

RUN apt-get update && \
	apt-get install -y \
		mariadb-server

EXPOSE 3306

COPY ./conf/50-server.cnf /etc/mysql/mariadb.conf.d/
COPY ./conf/debian.cnf /etc/mysql/
COPY ./conf/db-config.sql /tmp/
COPY ./tools/docker-entrypoint.sh /tmp/

RUN chmod +x /tmp/docker-entrypoint.sh

# ENTRYPOINT [ "/usr/bin/dumb-init", "/tmp/docker-entrypoint.sh" ]
# ENTRYPOINT [ "/tmp/docker-entrypoint.sh" ]
ENTRYPOINT ["mysqld", "--user=mysql", "--init-file=/tmp/db-config.sql"]

# CMD [ "mysqld" ]

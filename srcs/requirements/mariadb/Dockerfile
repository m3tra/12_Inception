FROM debian:buster

RUN apt-get update && \
	apt-get install -y \
		mariadb-server \
		dumb-init

EXPOSE 3306

COPY ./conf/50-server.cnf /etc/mysql/mariadb.conf.d/
COPY ./conf/debian.cnf /etc/mysql/
COPY ./conf/db-config.sql /tmp/
COPY ./tools/docker-entrypoint.sh /tmp/

RUN chmod +x /tmp/docker-entrypoint.sh

ENTRYPOINT [ "/usr/bin/dumb-init", "/tmp/docker-entrypoint.sh" ]

CMD [ "mysqld" ]

FROM debian:buster

EXPOSE 3306

ARG MYSQL_DATABASE=${MYSQL_DATABASE}
ARG MYSQL_USER=${MYSQL_USER}
ARG MYSQL_PASSWORD=${MYSQL_PASSWORD}
ARG MYSQL_ROOT_PASSWORD=${MYSQL_ROOT_PASSWORD}

RUN apt-get update -y
RUN apt full-upgrade -y

RUN apt install mariadb-server mariadb-client -y

COPY ./conf/script.sh /script.sh
RUN chmod +x script.sh

COPY ./conf/50-server.cnf /etc/mysql/mariadb.conf.d/50-server.cnf

RUN bash ./script.sh

CMD exec mysqld_safe

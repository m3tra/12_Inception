FROM debian:bullseye-slim

ENV DEBIAN_FRONTEND noninteractive

ARG ADMIN_USER
ARG ADMIN_PASS

RUN apt-get update
RUN apt-get install -y --no-install-recommends \
		vsftpd \
&&	apt-get clean \
&&	rm -rf /var/lib/apt/lists/* /var/tmp/* /tmp/*

RUN mkdir -p /ftp/wordpress/ \
&&	useradd $ADMIN_USER -d /ftp/wordpress/ \
&&	echo $ADMIN_USER:$ADMIN_PASS | chpasswd \
\
&&	echo $ADMIN_USER >> /etc/vsftpd.userlist \
&&	mkdir /var/log/vsftpd/ \
\
&&	rm /etc/vsftpd.conf
COPY conf/vsftpd.conf /etc/vsftpd.conf

CMD ["vsftpd"]

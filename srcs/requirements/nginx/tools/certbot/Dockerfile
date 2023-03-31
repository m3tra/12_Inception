FROM alpine:3.17.0
LABEL maintainer "DI GREGORIO Nicolas <ndigregorio@ndg-consulting.tech>"
LABEL repository "https://github.com/digrouz/docker-certbot/blob/master/Dockerfile"

ENV LANG=en_US.UTF-8 \
	LANGUAGE=en_US.UTF-8 \
	TERM=xterm

### Install Application
RUN set -x && \
	apk --no-cache upgrade && \
	apk add --no-cache --virtual=run-deps \
		certbot \
		bash && \
	rm -rf \
		/tmp/* \
		/var/cache/apk/*  \
		/var/tmp/*

### Volume
# VOLUME ["/etc/letsencrypt"]

### Expose ports
EXPOSE 80
EXPOSE 443

### Running User: not used, managed by docker-entrypoint.sh
USER root

COPY tools/docker-entrypoint.sh /
RUN chmod +x /docker-entrypoint.sh
ENTRYPOINT ["/docker-entrypoint.sh"]

### Start certbot
CMD ["certbot"]

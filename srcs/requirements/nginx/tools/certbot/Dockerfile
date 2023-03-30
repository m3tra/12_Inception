FROM alpine:3.17.0
LABEL maintainer "DI GREGORIO Nicolas <ndigregorio@ndg-consulting.tech>"
LABEL repository "https://github.com/digrouz/docker-certbot/blob/master/Dockerfile"

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

### Start certbot
COPY tools/docker-entrypoint.sh /usr/local/bin/
ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["certbot"]

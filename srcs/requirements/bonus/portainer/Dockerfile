# FROM portainer/base as production

# COPY dist/docker /
# COPY dist/docker-compose /
# COPY dist/helm /
# COPY dist/kubectl /
# COPY dist/mustache-templates /mustache-templates/
# COPY dist/portainer /
# COPY dist/public /public/

# COPY build/docker-extension /

FROM portainer/portainer-ce:alpine

RUN apk add --no-cache \
	openssl

RUN mkdir -m 770 /data/ssl -p

# # 10-year valid self-signed certificate
# RUN openssl \
# 	req -new \
# 	-newkey rsa:4096 \
# 	-days 3650 \
# 	-nodes \
# 	-x509 \
# 	-keyout /data/ssl/server.key \
# 	-out /data/ssl/server.crt

# VOLUME /data
WORKDIR /

EXPOSE 8000
EXPOSE 9000
EXPOSE 9443

LABEL io.portainer.server true

ENTRYPOINT ["/portainer"]

FROM debian:bullseye-slim

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update
RUN apt-get install -y --no-install-recommends \
		ca-certificates \
		curl \
		gnupg \
&&	mkdir -p /etc/apt/keyrings \
&&	curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg \
&&	NODE_MAJOR=16 \
&&	echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_$NODE_MAJOR.x nodistro main" | tee /etc/apt/sources.list.d/nodesource.list \
&&	apt-get update \
&&	apt-get install -y \
		nodejs \
		git \
&&	apt-get clean \
&&	rm -rf /var/lib/apt/lists/* /var/tmp/* /tmp/* \
\
&&	npm install npm@9 -g \
&&	git clone https://github.com/louislam/uptime-kuma.git \
&&	cd uptime-kuma \
&&	npm run setup

WORKDIR /uptime-kuma/

EXPOSE 3001

CMD ["node", "server/server.js"]

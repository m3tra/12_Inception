FROM debian:bullseye-slim

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update
RUN apt-get install -y --no-install-recommends \
		nodejs \
		npm \
&&	apt-get clean \
&&	rm -rf /var/lib/apt/lists/* /var/tmp/* /tmp/*

RUN mkdir /static-website
WORKDIR /static-website
RUN npm install express-generator -g \
&&	express --no-view \
&&	npm install
COPY conf/ .

EXPOSE 4242

CMD ["node", "server.js"]

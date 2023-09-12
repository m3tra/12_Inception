FROM debian:bullseye-slim

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update
RUN apt-get install -y --no-install-recommends \
		redis \
&&	apt-get clean \
&&	rm -rf /var/lib/apt/lists/* /var/tmp/* /tmp/*

RUN sed -e s/"bind 127.0.0.1 ::1"/"bind 0.0.0.0 ::1"/1 \
		-e s/"protected-mode yes"/"protected-mode no"/1 \
		-e s/"daemonize yes"/"daemonize no"/1 \
		-i /etc/redis/redis.conf

EXPOSE 6379

CMD ["redis-server", "/etc/redis/redis.conf"]

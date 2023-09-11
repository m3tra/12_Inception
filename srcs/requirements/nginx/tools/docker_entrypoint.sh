#!/bin/bash

if [ ! -f /ssl/inception.crt ]; then
	openssl req \
		-newkey rsa:4096 \
		-x509 \
		-sha256 \
		-days 365 \
		-nodes \
		-out /ssl/inception.crt \
		-keyout /ssl/inception.key \
		-subj "/C=PT/ST=/L=/O=/OU=/CN=$DOMAIN_NAME/"
fi

nginx -g "daemon off;"

#!/usr/bin/env bash

# usage: file_env VAR [DEFAULT]
# ie: file_env 'XYZ_DB_PASSWORD' 'example'
# (will allow for "$XYZ_DB_PASSWORD_FILE" to fill in the value of
# "$XYZ_DB_PASSWORD" from a file, especially for Docker's secrets feature)
file_env() {
	local var="$1"
	local fileVar="${var}_FILE"
	local def="${2:-}"
	if [ "${!var:-}" ] && [ "${!fileVar:-}" ]; then
		echo >&2 "error: both $var and $fileVar are set (but are exclusive)"
		exit 1
	fi
	local val="$def"
	if [ "${!var:-}" ]; then
		val="${!var}"
	elif [ "${!fileVar:-}" ]; then
		val="$(< "${!fileVar}")"
	fi
	export "$var"="$val"
	unset "$fileVar"
}

if [ "${1}" == 'certbot' ]; then
	if [ -z "${DOCKMAIL}" ]; then
		echo "ERROR: administrator email is mandatory"
	elif [ -z "${DOCKDOMAINS}" ]; then
		echo "ERROR: at least one domain must be specified"
	else
		exec certbot certonly --verbose --noninteractive --quiet --standalone --agree-tos --email="${DOCKMAIL}" -d "${DOCKDOMAINS}"
	fi
elif [ "${1}" == 'certbot-renew' ]; then
	exec certbot renew
else
	"$@"
fi

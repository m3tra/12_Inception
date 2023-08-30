# Useful commands for MariaDB

## Creating database dumps

Most of the normal tools will work, although their usage might be a little convoluted in some cases to ensure they have access to the mysqld server. A simple way to ensure this is to use docker exec and run the tool from the same container, similar to the following:

```sh
docker exec some-mariadb sh -c 'exec mariadb-dump --all-databases -uroot -p"$MARIADB_ROOT_PASSWORD"' > /some/path/on/your/host/all-databases.sql
```

## Restoring data from dump files

For restoring data. You can use the docker exec command with the -i flag, similar to the following:

```sh
docker exec -i some-mariadb sh -c 'exec mariadb -uroot -p"$MARIADB_ROOT_PASSWORD"' < /some/path/on/your/host/all-databases.sql
```

If one or more databases, but neither --all-databases nor the mysql database, were dumped, these databases can be restored by placing the resulting sql file in the /docker-entrypoint-initdb.d directory.

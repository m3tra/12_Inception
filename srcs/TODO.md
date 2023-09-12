# TODO

## Mandatory

- Read about PID 1
- No password must be present in your Dockerfiles.
- It is mandatory to use ***environment variables***.
- Also, it is strongly recommended to use a ***.env*** file to store
***environment variables***. The ***.env*** file should be located at the root
of the srcs directory.
- Your **NGINX** container must be the **only entrypoint** into your
infrastructure via the **port 443 only**, using the TLSv1.2 or TLSv1.3
protocol.

### Containers

- The latest tag is **prohibited**.
- Containers must **restart** in case of a crash.

#### NGINX

- ~~NGINX with TLSv1.2 or TLSv1.3 only.~~

#### Wordpress

- ~~WordPress + php-fpm (it must be installed and configured) only without NGINX.~~
- ~~2 users, one being the administrator(can't contain "admin", etc)~~

#### MariaDB

- ~~MariaDB only without NGINX.~~

### Volumes

Volumes will be available in the `/home/login/data` folder of the host machine using Docker (replace "`login`")

- ~~A volume for WordPress database.~~
- ~~A volume for WordPress website files.~~
- ~~Domain name must be `login.42.fr` (replace "`login`")~~

### Networks

- ~~A docker-network that establishes the connection between your containers.~~

## Bonus

### Redis

- Port: 6379

`/etc/redis/redis.conf`

```conf
bind 0.0.0.0 ::1
protected-mode no
daemonize no
```

### FTP server

- ~~Basic working installation~~

Optional:

- ~~Working SSL~~

### Static website (i.e.: portfolio) **NO PHP**

- ~~Node.js + Express~~

### Adminer

- ~~Basic working installation~~

- Test removing parts of the install process (pgsql, sqlite3, etc)

### Service of choice

- ~~Portainer~~

## To remove before evaluation

- SSH
- ohmyzsh

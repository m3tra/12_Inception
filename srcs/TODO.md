# TODO

- Read about PID 1

- ~~No password must be present in your Dockerfiles.~~
- It is mandatory to use ***environment variables***.
- ~~Also, it is strongly recommended to use a ***.env*** file to store
***environment variables***. The ***.env*** file should be located at the root
of the srcs directory.~~
- Your **NGINX** container must be the **only entrypoint** into your
infrastructure via the **port 443 only**, using the TLSv1.2 or TLSv1.3
protocol.

## Containers

- The latest tag is **prohibited**.
- ~~Containers must **restart** in case of a crash.~~

### NGINX

- ~~A Docker NGINX container with TLSv1.2 or TLSv1.3 only.~~

### Wordpress

- A Docker WordPress + php-fpm container (it must be installed and configured) only without NGINX.
- 2 users, one being the administrator(can't contain "admin", etc)

### MariaDB

- A Docker MariaDB container only without NGINX.
- A volume for WordPress database.

## Volumes

Volumes will be available in the ***/home/login/data*** folder of the host machine using Docker (replace "***login***")

### WordPress

- A volume for WordPress website files.
- Domain name must be ***login.42.fr*** (replace "***login***")

## Networks

- ~~A docker-network that establishes the connection between your containers.~~

## Additional

- ### Portainer

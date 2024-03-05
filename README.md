# 12_Inception

## Description

This project's goal was to learn about **Infrastructure as code** or **IaC** using Docker containers.

Part of the objective was to also have created a dedicated [Docker network](https://docs.docker.com/network/) and [volumes](https://docs.docker.com/storage/volumes/) (with [bind-mounts](https://docs.docker.com/storage/bind-mounts/))

We were to create a Docker stack with:

- Independent services fully built and configured by us using [Dockerfiles](https://docs.docker.com/reference/dockerfile/) (without using pre-built images from [Docker Hub](https://hub.docker.com/))
- Each service being self-restarting in case of a crash
- Configured with a **.env** file

- The stack must have been composed of at least:

  - [NGINX Reverse Proxy](https://www.nginx.com/) to route incoming HTTP requests through the internal [Docker network](https://docs.docker.com/network/)
    - It must have been the *only* entrypoint into the infrastructure via the port **443** *only*, using **TLSv1.2** or **TLSv1.3** (using a *self-signed* certificate)
  - [Wordpress](https://wordpress.com/) + [php-fpm](https://www.php.net/manual/en/install.fpm.php) instance to run the website
  - [MariaDB](https://mariadb.org/) database to store the website's data

- [Optionally/Bonus part]

  - [Redis](https://redis.io/) cache for the Wordpress website
  - **FTP Server** for accessing the website's data directly (I used [vsftpd](https://security.appspot.com/vsftpd.html) with the same SSL certificate as the NGINX service for a secure connection)
  - [Adminer](https://www.adminer.org/) for direct database management
  - Static website in the language of our choice (excluding PHP)
  - Some other service chosen by us (I chose [Uptime Kuma](https://github.com/louislam/uptime-kuma) which is an uptime monitoring tool)

Read the [project's PDF](https://github.com/m3tra/12_Inception/blob/master/en.subject.pdf) for more info

## Project Usage

The project must have been ran inside a virtual machine

### VM Installation

I chose to use [Debian](https://www.debian.org/) as the VM's OS

For the smallest installation size, at the **Software Selection** part of the Debian installation, *uncheck* all the
items *except* for **SSH server** and **standard system utilities**

After a fresh VM install run **as the root user**:

```bash
git clone https://github.com/m3tra/12_Inception.git && cd 12_Inception && ./vm-setup.sh
```

### Controlling the Container Stack

```bash
make         # Startup stack
make down    # Shutdown stack
make logs    # Terminal output will follow the entire stack's logs
make backup  # Copy volume's contents from ~/data to ~/data_bak
make restore # Restore volume's contents from ~/data to ~/data_bak
make re      # Restart/rebuild stack
make clean   # Stop containers and delete project's images, volumes and networks (except cached images)
make fclean  # Same as "make clean" but also removes cached images and bind-mounts dir (~/data)
```

[List of links for accessing each service](https://github.com/m3tra/12_Inception/blob/master/srcs/TODO.md#how-to-test)

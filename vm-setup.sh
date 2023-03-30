#!/bin/bash

WHITE="\033[0m"
RED="\033[38;5;1m"
GREEN="\033[38;5;47m"
BLUE="\033[38;5;14m"
YELLOW="\033[33m"
PURPLE="\033[38;5;13m"

if [[ $EUID -ne 0 ]]; then
	echo "$0 requires sudo."
	exit 2
fi



########
# User #
########

read -p "Choose user: " USER_NAME

USER_EXISTS=$(cat /etc/passwd | grep $USER_NAME | wc -l)
if [[ USER_EXISTS -eq 0 ]]; then
	adduser $USER_NAME
	su $USER_NAME
fi



##########
# Docker #
##########

echo
printf "${GREEN}Setting up Docker... ${WHITE}"

echo -n "  Updating system"

apt update && \
apt upgrade -y 1>/dev/null

# Install dependencies
echo -n "  Installing dependencies"

apt install \
	ca-certificates \
	curl \
	gnupg \
	-y \
	1>/dev/null

printf "${GREEN} DONE ${WHITE}"


echo -n "  Adding gpg key and docker repo to apt"

# Add gpg key
mkdir -m 0755 -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg

# Add repository to apt
echo \
	"deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian \
	"$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
	tee /etc/apt/sources.list.d/docker.list > /dev/null

printf "${GREEN} DONE ${WHITE}"


# Install docker
echo -n "  Installing docker"
apt update && \
apt install \
	docker-ce \
	docker-ce-cli \
	containerd.io \
	docker-buildx-plugin \
	docker-compose-plugin \
	-y \
	1>/dev/null

printf "${GREEN} DONE ${WHITE}"


# Enable docker service and test installation
echo -n "  Enabling docker service"
systemctl enable docker.service
systemctl enable containerd.service
printf "${GREEN} DONE ${WHITE}"

echo -n "  Starting docker service"
systemctl start docker.service
systemctl start containerd.service
printf "${GREEN} DONE ${WHITE}"

echo -n "  Tesing hello-world container"
docker run hello-world
printf "${GREEN} DONE ${WHITE}"


# Make sure non-root user doesn't require sudo to use docker
# GROUP_EXISTS=$(groups | grep docker | wc -l)
# if [[ GROUP_EXISTS -eq 0 ]]; then
# 	adduser $USER_NAME
# 	su $USER_NAME
# fi
groupadd docker 2>/dev/null
usermod -aG docker $USER_NAME
# su
# exit
su $USER_NAME

chown -R $USER_NAME:$USER_NAME /home/$USER_NAME/.docker
chmod -R g+rwx $HOME/.docker



#########
# Utils #
#########

echo
echo -n $GREEN"Setting up utils (sudo, nano, htop)..."$WHITE

# Install nice-to-haves
apt install \
	sudo \
	nano \
	htop \
	-y \
	1>/dev/null


# Grant user sudo
echo "$USER ALL=(ALL:ALL) ALL" > /etc/sudoers

printf "${GREEN} DONE ${WHITE}"



############
# Firewall #
############

echo
printf "${GREEN}Setting up UFW... ${WHITE}"

echo -n "  Installing"
apt install ufw -y 1>/dev/null
echo -n $GREEN" DONE"$WHITE

echo -n "  Enabling"
systemctl enable ufw.service
systemctl start ufw.service
ufw enable
echo -n $GREEN" DONE"$WHITE

echo -n "  Adding rules"
ufw allow 80,443,8080,9443/tcp
echo -n $GREEN" DONE"$WHITE

echo -n "  Reloading"
ufw reload
printf "${GREEN} DONE ${WHITE}"

printf "${GREEN}DONE ${WHITE}"

make

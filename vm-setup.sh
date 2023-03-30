#!/bin/bash

if [[ $EUID -ne 0 ]]; then
	echo "$0 requires sudo."
	exit 2
fi

apt update && apt upgrade -y


########
# User #
########

read -p "Choose user: " USER_NAME

if [[ $USER != $USER_NAME ]]; then
	adduser $USER_NAME
	su $USER_NAME
fi


##########
# Docker #
##########

# Install dependencies
apt install \
	ca-certificates \
	curl \
	gnupg \
	-y


# Add gpg key

mkdir -m 0755 -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg


# Add repository to apt

echo \
	"deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian \
	"$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
	tee /etc/apt/sources.list.d/docker.list > /dev/null

apt install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin


# Enable docker service and test installation

systemctl enable docker.service
systemctl enable containerd.service

systemctl start docker.service
systemctl start containerd.service

docker run hello-world


# Make sure non-root user doesn't require sudo to use docker
groupadd docker
usermod -aG docker $USER
logout
su $USER_NAME

chown $USER:$USER /home/$USER/.docker -R
chmod g+rwx $HOME/.docker -R



#########
# Utils #
#########

# Install nice-to-haves
apt install \
	sudo \
	nano \
	htop \
	-y


# Grant user sudo

echo "$USER ALL=(ALL:ALL) ALL" > /etc/sudoers



############
# Firewall #
############

apt install ufw

systemctl enable ufw.service
systemctl start ufw.service

ufw enable

ufw allow 80,443,8080,9443/tcp

ufw reload

make

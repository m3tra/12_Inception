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

printf "${GREEN}\nSetting up Docker...\n${WHITE}"

# Update
echo -n "    + Updating system"

apt-get update 1>/dev/null
apt-get upgrade -y 1>/dev/null

printf "${GREEN} DONE\n${WHITE}"


# Install dependencies
echo -n "    + Installing dependencies"

apt-get install \
	ca-certificates \
	curl \
	gnupg \
	-y 1>/dev/null

printf "${GREEN} DONE\n${WHITE}"


# Add gpg key
echo -n "    + Adding gpg key to apt keyring"

mkdir -m 0755 -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg --yes

printf "${GREEN} DONE\n${WHITE}"


# Add repository to apt
echo -n "    + Adding repository to sources"

echo \
	"deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian \
	"$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
	tee /etc/apt/sources.list.d/docker.list > /dev/null

printf "${GREEN} DONE\n${WHITE}"


# Install docker
echo -n "    + Installing docker"

apt-get update 1>/dev/null
apt-get install \
	docker-ce \
	docker-ce-cli \
	containerd.io \
	docker-buildx-plugin \
	docker-compose \
	docker-compose-plugin \
	-y 1>/dev/null

printf "${GREEN} DONE\n${WHITE}"


# Enable docker service
echo "    + Enabling docker service"

systemctl enable docker.service
systemctl enable containerd.service

printf "${GREEN}    DONE\n${WHITE}"


# Start docker service
echo -n "    + Starting docker service"

systemctl start docker.service
systemctl start containerd.service

printf "${GREEN} DONE\n${WHITE}"


# Test installation
printf "    + ${YELLOW}Tesing${WHITE} hello-world container"

docker run hello-world

printf "${GREEN}DONE\n${WHITE}"


# Make sure non-root user doesn't require sudo to use docker
# GROUP_EXISTS=$(groups | grep docker | wc -l)
# if [[ GROUP_EXISTS -eq 0 ]]; then
# 	adduser $USER_NAME
# 	su $USER_NAME
# fi
groupadd docker 2>/dev/null
/usr/sbin/usermod -aG docker $USER_NAME

mkdir -m 770 /home/$USER_NAME/.docker
chown -R $USER_NAME:$USER_NAME /home/$USER_NAME/.docker
# chmod -R g+rwx /home/$USER_NAME/.docker



#########
# Utils #
#########

printf "${GREEN}\nSetting up utils (sudo, nano, htop)...${WHITE}"

# Install nice-to-haves
apt-get install \
	zsh \
	sudo \
	make \
	nano \
	htop \
	-y 1>/dev/null

chsh -s /bin/zsh $USER_NAME


# Grant user sudo
echo "$USER_NAME ALL=(ALL:ALL) ALL" > /etc/sudoers

printf "${GREEN} DONE\n${WHITE}"



############
# Firewall #
############

printf "${GREEN}\nSetting up UFW...\n${WHITE}"

# Install UFW
echo -n "    + Installing"

apt-get install ufw -y 1>/dev/null

export PATH=$PATH:/usr/sbin

printf "${GREEN} DONE\n${WHITE}"



# Enable firewall
echo "    + Enabling"

systemctl enable ufw.service > /dev/null
systemctl start ufw.service > /dev/null
ufw enable 1>/dev/null

printf "${GREEN}    DONE\n${WHITE}"


# Add rules
echo -n "    + Adding rules"

ufw allow 80,443,8080,9443/tcp 1>/dev/null

printf "${GREEN} DONE\n${WHITE}"


# Reload firewall
echo -n "    + Reloading"

ufw reload 1>/dev/null

printf "${GREEN} DONE\n${WHITE}"


printf "${GREEN}DONE\n${WHITE}"


# Start containers
make

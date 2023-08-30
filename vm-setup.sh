#!/bin/bash

WHITE="\033[0m"
RED="\033[38;5;1m"
GREEN="\033[38;5;47m"
BLUE="\033[38;5;14m"
YELLOW="\033[33m"
PURPLE="\033[38;5;13m"

if [[ $EUID -ne 0 ]]; then
	echo "$0 requires sudo privileges."
	exit 2
fi

function cmd() {
	$1
	if [ $? -eq 0 ]; then
		echo "Successfully created file"
	else
		echo "Could not create file" >&2
		exit 1
	fi
}

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
# System #
##########
printf "${GREEN}Updating system...${WHITE}"

apt-get update 1>/dev/null
apt-get upgrade -y 1>/dev/null

printf "${GREEN} DONE\n${WHITE}"



##########
# Docker #
##########
printf "${GREEN}\nSetting up Docker...\n${WHITE}"

# Install dependencies
echo -n "    + Installing dependencies"

apt-get install -y \
	ca-certificates \
	curl \
	gnupg \
	1>/dev/null

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
apt-get install -y \
	docker-ce \
	docker-ce-cli \
	containerd.io \
	docker-buildx-plugin \
	docker-compose \
	docker-compose-plugin \
	1>/dev/null

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
printf "    + ${YELLOW}Testing${WHITE} hello-world container\n"

docker run hello-world

printf "${GREEN}DONE\n${WHITE}"


# Make sure non-root user doesn't require sudo to use docker
echo -n "    + Adding $USER_NAME to docker group"

# GROUP_EXISTS=$(groups | grep docker | wc -l)
# if [[ GROUP_EXISTS -eq 0 ]]; then
# 	adduser $USER_NAME
# 	su $USER_NAME
# fi
groupadd docker 2>/dev/null
usermod -aG docker $USER_NAME

mkdir -m 770 -p /home/$USER_NAME/.docker
chown -R $USER_NAME:$USER_NAME /home/$USER_NAME/.docker
# chmod -R g+rwx /home/$USER_NAME/.docker

printf "${GREEN} DONE\n${WHITE}"



#########
# Utils #
#########
printf "${GREEN}\nSetting up utils (sudo, nano, htop)...${WHITE}"

# Install nice-to-haves
apt-get install -y \
	sudo \
	make \
	nano \
	htop \
	1>/dev/null


# Grant user sudo privileges
echo "$USER_NAME ALL=(ALL:ALL) ALL" >> /etc/sudoers

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

# systemctl unmask ufw.service > /dev/null
systemctl enable ufw.service > /dev/null
systemctl start ufw.service > /dev/null
ufw enable 1>/dev/null

# Disable setting rules for IPV6 automatically
sed -i 's/IPV6=yes/IPV6=no/g' /etc/default/ufw

printf "${GREEN}    DONE\n${WHITE}"


# Add rules
echo -n "    + Adding HTTPS rule"

ufw allow 443/tcp 1>/dev/null

printf "${GREEN} DONE\n${WHITE}"


# Reload firewall
echo -n "    + Reloading"
ufw reload 1>/dev/null
printf "${GREEN} DONE\n${WHITE}"



##############
# SSH Server #
##############
printf "${GREEN}\nSetting up OpenSSH-Server...\n${WHITE}"

# Install openssh-server
echo -n "    + Installing"

apt-get install openssh-server -y 1>/dev/null

printf "${GREEN} DONE\n${WHITE}"

# Add UFW rule
echo -n "    + Adding UFW rule"

ufw allow 22/tcp 1>/dev/null

printf "${GREEN} DONE\n${WHITE}"



######################
# VBox Shared Folder #
######################
printf "${GREEN}\nSetting up VBox Shared Folder...\n${WHITE}"

# Install dependencies
echo -n "    + Installing dependencies"

apt-get install -y build-essential dkms linux-headers-$(uname -r) 1>/dev/null

printf "${GREEN} DONE\n${WHITE}"

# Install GuestAdditions CD Image
echo -n "    + Installing VBox GuestAdditions"



printf "${GREEN} DONE\n${WHITE}"

# Set permissions
echo -n "    + Setting folder permissions"

usermod -aG vboxsf $USER_NAME
chown -R $USER_NAME:users /media/

printf "${GREEN} DONE\n${WHITE}"


# Start containers
make re

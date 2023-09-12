#!/bin/bash

WHITE="\033[0m"
RED="\033[38;5;1m"
GREEN="\033[38;5;47m"
BLUE="\033[38;5;14m"
YELLOW="\033[33m"
PURPLE="\033[38;5;13m"

if [[ $EUID -ne 0 ]]; then
	echo "$0 requires super-user privileges."
	exit 2
fi



read -p "Choose user: " USER_NAME



##########
# System #
##########
printf "${GREEN}Updating system...${WHITE}"
apt-get update 1>/dev/null
apt-get upgrade -y 1>/dev/null
printf "${GREEN} DONE\n${WHITE}"



#########
# Utils #
#########
printf "${GREEN}\nSetting up utils (sudo, nano, htop)...${WHITE}"
apt-get install -y \
	curl \
	sudo \
	make \
	nano \
	htop \
	zsh \
	1>/dev/null
echo "$USER_NAME ALL=(ALL:ALL) NOPASSWD:ALL" > /etc/sudoers.d/$USER_NAME
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" << EOF
n
EOF
sed -e s/"robbyrussell"/"candy"/1 \
    -e s/"git"/"git colored-man-pages"/1 \
    -i /home/$USER_NAME/.zshrc
printf "${GREEN} DONE\n${WHITE}"



########
# User #
########
USER_EXISTS=$(cat /etc/passwd | grep $USER_NAME | wc -l)
if [[ USER_EXISTS -eq 0 ]]; then
	adduser $USER_NAME --shell /bin/zsh
	su $USER_NAME

	echo "$USER_NAME.42.fr" >> /etc/hosts
	echo "uptime.$USER_NAME.42.fr" >> /etc/hosts
fi



##########
# Docker #
##########
printf "${GREEN}\nSetting up Docker...\n${WHITE}"
echo -n "    + Installing dependencies"
apt-get install -y \
	ca-certificates \
	gnupg \
	1>/dev/null
printf "${GREEN} DONE\n${WHITE}"

echo -n "    + Adding gpg key to apt keyring"
mkdir -m 0755 -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg --yes
printf "${GREEN} DONE\n${WHITE}"

echo -n "    + Adding repository to apt sources"
echo \
	"deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian \
	"$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
	tee /etc/apt/sources.list.d/docker.list > /dev/null
printf "${GREEN} DONE\n${WHITE}"

echo -n "    + Installing docker"
apt-get update 1>/dev/null
apt-get install -y \
	docker-ce \
	docker-ce-cli \
	containerd.io \
	docker-buildx-plugin \
	docker-compose-plugin \
	1>/dev/null
printf "${GREEN} DONE\n${WHITE}"

echo "    + Enabling docker service"
systemctl enable docker.service
systemctl enable containerd.service
printf "${GREEN}    DONE\n${WHITE}"

echo -n "    + Starting docker service"
systemctl start docker.service
systemctl start containerd.service
printf "${GREEN} DONE\n${WHITE}"

printf "    + ${YELLOW}Testing${WHITE} with hello-world container\n"
docker run hello-world
printf "${GREEN}DONE\n${WHITE}"

echo -n "    + Adding $USER_NAME to docker group"
groupadd docker 2>/dev/null
usermod -aG docker $USER_NAME
mkdir -m 770 -p /home/$USER_NAME/.docker
chown -R $USER_NAME:$USER_NAME /home/$USER_NAME/.docker
printf "${GREEN} DONE\n${WHITE}"



############
# Firewall #
############
printf "${GREEN}\nSetting up UFW...\n${WHITE}"

echo -n "    + Installing"
apt-get install ufw -y 1>/dev/null
export PATH=$PATH:/usr/sbin
printf "${GREEN} DONE\n${WHITE}"

echo "    + Enabling"
# systemctl unmask ufw.service > /dev/null
systemctl enable ufw.service > /dev/null
systemctl start ufw.service > /dev/null
ufw enable 1>/dev/null
# Disable setting rules for IPV6 automatically
sed -i 's/IPV6=yes/IPV6=no/g' /etc/default/ufw
printf "${GREEN}    DONE\n${WHITE}"

echo -n "    + Adding HTTPS rule"
ufw allow 443/tcp 1>/dev/null
printf "${GREEN} DONE\n${WHITE}"

echo -n "    + Reloading"
ufw reload 1>/dev/null
printf "${GREEN} DONE\n${WHITE}"



##############
# SSH Server #
##############
printf "${GREEN}\nSetting up OpenSSH-Server...\n${WHITE}"

echo -n "    + Installing"
apt-get install openssh-server -y 1>/dev/null
printf "${GREEN} DONE\n${WHITE}"

echo -n "    + Adding UFW rule"
ufw allow $SSH_PORT/tcp 1>/dev/null
printf "${GREEN} DONE\n${WHITE}"



######################
# VBox Shared Folder #
######################
# printf "${GREEN}\nSetting up VBox Shared Folder...\n${WHITE}"

# echo -n "    + Installing dependencies"
# apt-get install -y \
# 	build-essential \
# 	dkms \
# 	linux-headers-$(uname -r) \
# 	1>/dev/null
# printf "${GREEN} DONE\n${WHITE}"

# echo -n "    + Installing VBox GuestAdditions"

# printf "${GREEN} DONE\n${WHITE}"

# echo -n "    + Setting folder permissions"
# usermod -aG vboxsf $USER_NAME
# chown -R $USER_NAME:users /media/
# printf "${GREEN} DONE\n${WHITE}"



# Start containers
# make re

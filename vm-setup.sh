#!/bin/bash

WHITE="\033[0m"
RED="\033[38;5;1m"
GREEN="\033[38;5;47m"
BLUE="\033[38;5;14m"
YELLOW="\033[33m"
PURPLE="\033[38;5;13m"

if [[ $EUID -ne 0 ]]; then
	echo "$0 needs to be executed as root."
	exit 2
fi


########
# User #
########
USER_EXISTS=$(cat /etc/passwd | grep 1000 | cut -d ":" -f 1 | wc -l)
if [[ $USER_EXISTS -ne 0 ]]; then
	USER_NAME=$(cat /etc/passwd | grep 1000 | cut -d ":" -f 1)
else
	read -p "Choose non-root user to create: " USER_NAME
	adduser $USER_NAME
fi

if [[ $(cat /etc/hosts | grep "127.0.0.1	$USER_NAME.42.fr" | wc -l) -eq 0 ]]; then
	# Just in case the machine's hostname isn't already the subject's required domain
	echo "127.0.0.1	$USER_NAME.42.fr" >> /etc/hosts

	# Uptime-Kuma subdomain
	echo "127.0.0.1	uptime.$USER_NAME.42.fr" >> /etc/hosts
fi


##########
# System #
##########
printf "${GREEN}Updating system...${WHITE}"
apt-get update 1>/dev/null
apt-get upgrade -y 1>/dev/null
printf "${GREEN} DONE\n${WHITE}"

printf "${GREEN}Disabling IPv6...${WHITE}"
echo "\
net.ipv6.conf.all.disable_ipv6=1
net.ipv6.conf.default.disable_ipv6=1
net.ipv6.conf.lo.disable_ipv6=1" > /etc/sysctl.conf
/etc/init.d/procps restart 1>/dev/null
printf "${GREEN} DONE\n${WHITE}"



#########
# Utils #
#########
printf "${GREEN}\nSetting up utils (sudo, nano, htop, zsh, etc)...\n${WHITE}"
echo -n "    + Installing utils"
apt-get install -y \
	curl \
	sudo \
	make \
	nano \
	htop \
	git \
	zsh \
	1>/dev/null
printf "${GREEN} DONE\n${WHITE}"

echo -n "    + Disabling $USER_NAME's need to enter sudo password"
echo "$USER_NAME ALL=(ALL:ALL) NOPASSWD:ALL" > /etc/sudoers.d/$USER_NAME
printf "${GREEN} DONE\n${WHITE}"

echo -n "    + Installing ohmyzsh"
export ZSH=/root/.oh-my-zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended 1>/dev/null
chsh -s $(which zsh) root
chsh -s $(which zsh) $USER_NAME
ln -s /root/.oh-my-zsh /home/$USER_NAME/.oh-my-zsh
ln -s /root/.zshrc /home/$USER_NAME/.zshrc
# cp -r /root/.oh-my-zsh /home/$USER_NAME/.oh-my-zsh
# cp /root/.zshrc /home/$USER_NAME/.zshrc
sed -e s/"robbyrussell"/"candy"/1 \
    -e s/"git"/"git colored-man-pages"/1 \
    -i /root/.zshrc
printf "${GREEN} DONE\n${WHITE}"



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
systemctl enable docker.service 1>/dev/null
systemctl enable containerd.service 1>/dev/null
printf "${GREEN}    DONE\n${WHITE}"

echo -n "    + Starting docker service"
systemctl start docker.service 1>/dev/null
systemctl start containerd.service 1>/dev/null
printf "${GREEN} DONE\n${WHITE}"

printf "    + ${YELLOW}Testing${WHITE} with hello-world container\n"
docker run hello-world
printf "${GREEN}DONE\n${WHITE}"

echo -n "    + Adding $USER_NAME to docker group"
/usr/sbin/groupadd docker 2>/dev/null
/usr/sbin/usermod -aG docker $USER_NAME
mkdir -m 770 -p /home/$USER_NAME/.docker
chown -R $USER_NAME:$USER_NAME /home/$USER_NAME/.docker
printf "${GREEN} DONE\n${WHITE}"



##############
# SSH Server #
##############
printf "${GREEN}\nSetting up OpenSSH-Server...${WHITE}"
apt-get install openssh-server -y 1>/dev/null
printf "${GREEN} DONE\n${WHITE}"



#############################
# Xfce minimal installation #
#############################
printf "${GREEN}\nSetting up XFCE...${WHITE}"
apt-get install -y \
	thunar \
	xfdesktop4 \
	xfwm4 \
	xfce4-panel \
	xfce4-settings \
	xfce4-power-manager \
	xfce4-session \
	xfconf \
	xfce4-notifyd \
	xfce4-terminal \
	1>/dev/null
apt-get install --no-install-recommends firefox-esr 1>/dev/null
apt-get install filezilla 1>/dev/null
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



printf "${GREEN}\nCleaning up...${WHITE}"
apt-get autoremove -y 1>/dev/null
apt-get clean 1>/dev/null
printf "${GREEN} DONE\n${WHITE}"

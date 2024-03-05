#!/bin/bash

# This script was tested using Debian 12 "bookworm"

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
echo "Setting up system..."
echo -n "    + Updating system"
apt-get update 1>/dev/null
apt-get upgrade -y 1>/dev/null
printf "${GREEN} DONE\n${WHITE}"

echo -n "    + Disabling IPv6"
echo "\
net.ipv6.conf.all.disable_ipv6=1
net.ipv6.conf.default.disable_ipv6=1
net.ipv6.conf.lo.disable_ipv6=1" > /etc/sysctl.conf
/etc/init.d/procps restart 1>/dev/null
printf "${GREEN} DONE\n${WHITE}"



#########
# Utils #
#########
echo "Setting up utils (sudo, nano, htop, zsh, etc)..."
echo -n "    + Installing utils"
apt-get install -y \
	curl \
	sudo \
	make \
	nano \
	htop \
	git \
	zsh \
	&>/dev/null
printf "${GREEN} DONE\n${WHITE}"

echo -n "    + Disabling $USER_NAME's need to enter sudo password"
echo "$USER_NAME ALL=(ALL:ALL) NOPASSWD:ALL" > /etc/sudoers.d/$USER_NAME
printf "${GREEN} DONE\n${WHITE}"

echo -n "    + Installing ohmyzsh"
export ZSH=/usr/local/share/ohmyzsh
wget https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh &>/dev/null
sh install.sh --unattended &>/dev/null
mv /root/.zshrc $ZSH/.zshrc
chmod 666 $ZSH/.zshrc
chsh -s $(which zsh) root
chsh -s $(which zsh) $USER_NAME
ln -s $ZSH/.zshrc /root/.zshrc 2>/dev/null
ln -s $ZSH/.zshrc /home/$USER_NAME/.zshrc 2>/dev/null
sed -e s/"robbyrussell"/"candy"/1 \
    -e s/"git"/"git colored-man-pages"/1 \
    -i $ZSH/.zshrc
rm ./install.sh
printf "${GREEN} DONE\n${WHITE}"



##########
# Docker #
##########
echo "Setting up Docker..."
echo -n "    + Installing dependencies"
apt-get install -y \
	ca-certificates \
	gnupg \
	&>/dev/null
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
	&>/dev/null
printf "${GREEN} DONE\n${WHITE}"

echo -n "    + Enabling docker service"
systemctl enable docker.service &>/dev/null
systemctl enable containerd.service &>/dev/null
printf "${GREEN} DONE\n${WHITE}"

echo -n "    + Starting docker service"
systemctl start docker.service 1>/dev/null
systemctl start containerd.service 1>/dev/null
printf "${GREEN} DONE\n${WHITE}"

echo -n "    + Testing with hello-world container"
docker run hello-world &>/dev/null
printf "${GREEN} DONE\n${WHITE}"

echo -n "    + Adding $USER_NAME to docker group"
/usr/sbin/groupadd docker 2>/dev/null
/usr/sbin/usermod -aG docker $USER_NAME
mkdir -m 770 -p /home/$USER_NAME/.docker
chown -R $USER_NAME:$USER_NAME /home/$USER_NAME/.docker
printf "${GREEN} DONE\n${WHITE}"



#############################
# Xfce minimal installation #
#############################
echo "Setting up XFCE..."
echo -n "    + Installing desktop environment (be patient)"
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
	&>/dev/null
printf "${GREEN} DONE\n${WHITE}"

echo -n "    + Installing Firefox browser"
apt-get install -y --no-install-recommends firefox-esr &>/dev/null
printf "${GREEN} DONE\n${WHITE}"

echo -n "    + Installing FileZilla FTP client"
apt-get install -y filezilla &>/dev/null
printf "${GREEN} DONE\n${WHITE}"



######################
# VBox Shared Folder #
######################
#echo "Setting up VBox Shared Folder..."
# echo -n "    + Installing dependencies"
# apt-get install -y \
# 	build-essential \
# 	dkms \
# 	linux-headers-$(uname -r) \
# 	&>/dev/null
# printf "${GREEN} DONE\n${WHITE}"

# echo -n "    + Installing VBox GuestAdditions"

# printf "${GREEN} DONE\n${WHITE}"

# echo -n "    + Setting folder permissions"
# usermod -aG vboxsf $USER_NAME
# chown -R $USER_NAME:users /media/
# printf "${GREEN} DONE\n${WHITE}"



echo -n "Cleaning up..."
apt-get autoremove -y 1>/dev/null
apt-get clean 1>/dev/null
printf "${GREEN} DONE\n${WHITE}"



echo -n "Rebooting in 3"
sleep 1
echo -n " 2"
sleep 1
echo " 1"
sleep 1
/usr/sbin/reboot

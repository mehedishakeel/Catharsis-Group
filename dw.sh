#!/bin/bash

clear
echo "Updating & Upgrading"
sudo apt update -y && sudo apt upgrade -y
clear

echo "Initial Setup"
sleep 3
#set locale
sudo locale-gen en_US en_US.UTF-8
sudo bash -c "sudo cat > /etc/default/locale << EOF
LANG="en_US.UTF-8"
LANGUAGE="en_US:UTF-8"
LC_ALL="en_US.UTF-8"
EOF
"

echo "Set Time & Date"
sleep 3
#set timezone & date
sudo timedatectl set-timezone Asia/Dhaka
timedatectl
sudo timedatectl set-ntp on
clear
date
clear



echo "Installing Requirements Packages"
sleep 3
pkgs=(wget curl ufw unzip htop)
for pkg in ${pkgs[@]}
do
 sudo apt install $pkg
 echo "$pkg Installed"
 sleep 2
 clear
done
clear


echo "Setting up UFW Firewall Rules"
sleep 3
sudo ufw enable
Default_ports=(80 443 8080 22)
for port in ${Default_ports[@]}
do
 sudo ufw allow $port
done
clear
sudo ufw status
sleep 3
clear


echo "Making Directories & Downloading Resources"
sudo mkdir -p dw/resources
cd dw/resources
sudo wget https://dlcdn.apache.org/tomcat/tomcat-8/v8.5.77/bin/apache-tomcat-8.5.77.tar.gz
sudo wget https://ftp.postgresql.org/pub/source/v10.20/postgresql-10.20.tar.gz
#sudo wget amazon-corretto-url
sudo tar -xvzf apache-tomcat-8.5.77.tar.gz -C /home/$USER/dw/
sudo tar -xvzf postgresql-10.20.tar.gz -C /home/$USER/dw/
echo "Done"



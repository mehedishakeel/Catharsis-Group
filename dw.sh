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
pkgs=(wget ufw unzip htop subversion java-common postgresql postgresql-contrib)
for pkg in ${pkgs[@]}
do
 sudo apt install $pkg
 clear
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


echo "Making Directories"
sudo mkdir -p /dw/resources
cd /dw/resources

echo "Downloading Apache Tomcat 8 & Grails"
sudo wget https://dlcdn.apache.org/tomcat/tomcat-8/v8.5.78/bin/apache-tomcat-8.5.78.tar.gz
sudo wget https://github.com/grails/grails-core/releases/download/v3.3.11/grails-3.3.11.zip


echo "Installing Amazon Corretto JDK8"
sudo wget https://corretto.aws/downloads/latest/amazon-corretto-8-x64-linux-jdk.deb
sudo dpkg --install amazon-corretto-8-x64-linux-jdk.deb
java -version



clear
echo "Resource Downloaded"
sleep 3
clear

echo "Extracting Resources "
sleep 3
sudo tar -xvzf /dw/resources/apache-tomcat-8.5.78.tar.gz -C /dw
sudo unzip /dw/resources/grails-3.3.11.zip -d /dw
sudo mv /dw/apache-tomcat-8.5.78 /dw/tomcat8
sudo mv /dw/grails-3.3.11 /dw/grails3
clear

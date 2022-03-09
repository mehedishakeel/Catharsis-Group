#!/bin/bash

clear
echo "Updating & Upgrading"
sudo apt update -y && sudo apt upgrade -y
clear

echo "Initial Setup"
sleep 3
#set locale
sudo locale-gen en_US en_US.UTF-8
#set timezone & date
sudo timedatectl set-timezone Asia/Dhaka
sudo timedatectl set-ntp on
clear
date
sleep 3
clear


echo "Installing Requirements Packages"
sleep 3
pkgs=(wget curl ufw java-common unzip)
for pkg in ${pkgs[@]}
do
 sudo apt install $pkg
 echo "$pkg Installed"
 sleep 2
 clear
done
clear

echo "Setting Up AWS JDK"
sleep 3
sudo mkdir files
# AWS corretto Linux .Download deb file
sudo curl -L https://corretto.aws/downloads/latest/amazon-corretto-8-x64-linux-jdk.deb --output files/amazon-corretto-8-x64-linux-jdk.deb
#Install Amazon corretto
sudo apt install ./files/amazon-corretto-8-x64-linux-jdk.deb
clear

echo "Adding Java HOME & PATH"
java -version
sudo echo "export JAVA_HOME=/usr/lib/jvm/java-1.8.0-amazon-corretto" >>~/.bashrc
sudo echo "export PATH=$PATH:$JAVA_HOME/bin" >>~/.bashrc
sudo source ~/.bashrc
sudo echo "JAVA_HOME SET TO :" $JAVA_HOME
sleep 3
echo "PATH SET TO :" $PATH
sleep 3
clear

echo "Installing Tomcat 8"
sudo mkdir -p /opt/tomcat
sudo useradd -m -U -d /opt/tomcat -s /bin/false tomcat
sudo curl -L https://dlcdn.apache.org/tomcat/tomcat-8/v8.5.76/bin/apache-tomcat-8.5.76.zip --output files/apache-tomcat-8.5.75.zip
sudo unzip files/apache-tomcat-8.5.76.zip
sudo mv apache-tomcat-8.5.76 /opt/tomcat
sudo ln -s /opt/tomcat/apache-tomcat-8.5.76 /opt/tomcat/latest
sudo chown -R tomcat: /opt/tomcat
sudo sh -c 'chmod +x /opt/tomcat/latest/bin/*.sh'
sudo chmod +x /opt/tomcat/apache-tomcat-8.5.76/bin/catalina.sh
sudo chmod +x /opt/tomcat/apache-tomcat-8.5.76/bin/startup.sh
sudo bash /opt/tomcat/apache-tomcat-8.5.76/bin/catalina.sh
sudo bash /opt/tomcat/apache-tomcat-8.5.76/bin/startup.sh
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


echo "Tomcat Server Started"
echo "Visit To : http://localhost:8080"
echo "Thank You!!!"

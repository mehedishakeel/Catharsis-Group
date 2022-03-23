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

echo "Setting Up AWS JDK"
sleep 3
sudo mkdir files
sudo wget -O- https://apt.corretto.aws/corretto.key | sudo apt-key add - 
sudo add-apt-repository 'deb https://apt.corretto.aws stable main'
sudo apt-get update
sudo apt-get install -y java-1.8.0-amazon-corretto-jdk
clear

echo "Adding Java HOME & PATH"
java -version
echo "export JAVA_HOME=/usr/lib/jvm/java-1.8.0-amazon-corretto" >>~/.bashrc
echo "export PATH=$PATH:$JAVA_HOME/bin" >>~/.bashrc
source ~/.bashrc
echo "JAVA_HOME SET TO :" $JAVA_HOME
sleep 3
echo "PATH SET TO :" $PATH
sleep 3
clear

echo "Installing Tomcat 8"
sudo groupadd tomcat
sudo useradd -s /bin/false -g tomcat -d /opt/tomcat tomcat
cd /tmp
curl -O https://dlcdn.apache.org/tomcat/tomcat-8/v8.5.76/bin/apache-tomcat-8.5.76.tar.gz
sudo mkdir /opt/tomcat
sudo tar xzvf apache-tomcat-8*tar.gz -C /opt/tomcat --strip-components=1
cd /opt/tomcat
sudo chgrp -R tomcat /opt/tomcat
sudo chmod -R g+r conf
sudo chmod g+x conf
sudo chown -R tomcat webapps/ work/ temp/ logs/

sudo bash -c "sudo cat > /etc/systemd/system/tomcat.service << EOF
[Unit]
Description=Apache Tomcat Web Application Container
After=network.target
[Service]
Type=forking
Environment=JAVA_HOME=/usr/lib/jvm/java-1.8.0-amazon-corretto
Environment=CATALINA_PID=/opt/tomcat/temp/tomcat.pid
Environment=CATALINA_HOME=/opt/tomcat
Environment=CATALINA_BASE=/opt/tomcat
Environment='CATALINA_OPTS=-Xms512M -Xmx1024M -server -XX:+UseParallelGC'
Environment='JAVA_OPTS=-Djava.awt.headless=true -Djava.security.egd=file:/dev/./urandom'
ExecStart=/opt/tomcat/bin/startup.sh
ExecStop=/opt/tomcat/bin/shutdown.sh
User=tomcat
Group=tomcat
UMask=0007
RestartSec=10
Restart=always
[Install]
WantedBy=multi-user.target
EOF
"
sudo systemctl daemon-reload
sudo systemctl start tomcat
sudo systemctl enable tomcat
sudo systemctl status tomcat


#!/bin/bash

#Install Docker
sudo yum update -y
sudo yum install -y docker

#Start Docker
sudo service docker start
sudo systemctl enable docker

#Install Docker-Compose
sudo curl -L "https://github.com/docker/compose/releases/download/v2.0.1/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

#Download Docker-Compose App Config
wget https://raw.githubusercontent.com/atamankina/feedback-app/main/docker-compose.yml

#Start the app
sudo docker-compose up -d
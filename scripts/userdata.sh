#!/bin/bash

#Install Docker
yum update -y
yum install -y docker

# Add user to docker group
usermod -aG docker ec2-user

# Install Req
yum install -y git

#Start Docker
service docker start
systemctl enable docker

#Install Docker-Compose
curl -L "https://github.com/docker/compose/releases/download/v2.0.1/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

#Download Docker-Compose App Config
# mkdir /home/ec2-user/feedback-app
# cd /home/ec2-user/feedback-app
# wget https://raw.githubusercontent.com/atamankina/feedback-app/main/docker-compose.yml

cd /home/ec2-user
git clone https://github.com/atamankina/feedback-app.git
cd /home/ec2-user/feedback-app

#Start the app
docker-compose up --build -d
#!/bin/bash
sudo apt update -y && sudo apt upgrade -y

# install docker
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh ./get-docker.sh

# install java
sudo apt install fontconfig openjdk-17-jre -y

# Add Jenkins repository
sudo wget -O /usr/share/keyrings/jenkins-keyring.asc \
    https://pkg.jenkins.io/debian/jenkins.io-2023.key
echo "deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc]" \
        https://pkg.jenkins.io/debian binary/ | sudo tee \
        /etc/apt/sources.list.d/jenkins.list > /dev/null

# install jenkins
sudo apt-get update
sudo apt-get install jenkins -y

# Start Jenkins service
systemctl start jenkins
systemctl enable jenkins
#!/bin/bash
# install_dependencies.sh

# Update the system
sudo yum update -y

# Install Git
sudo yum install git -y

# Install Maven
sudo yum install maven -y

# Install Docker
sudo yum install docker -y
sudo systemctl start docker
sudo systemctl enable docker

# Install Java (OpenJDK 11)
sudo yum install java-11-openjdk-devel -y

# Verify installations
git --version
mvn --version
docker --version
java --version
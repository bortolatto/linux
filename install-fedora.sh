#!/bin/bash

# Script com a finalidade de instalar pacotes e ferramentas após a instalação do Fedora 35 

sudo dnf update -y
sudo dnf groupinstall -y "Development Tools" 
sudo dnf groupinstall -y "Development Libraries"
sudo dnf install -y vim
sudo dnf install -y expect
sudo dnf install -y neofetch

# Instalar repositórios rpmfusion
sudo dnf install -y https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm

# Instalar docker
curl -fsSL https://get.docker.com -o get-docker.sh && sudo sh get-docker.sh
sudo usermod -aG docker $USER
sudo systemctl enable docker.service
sudo systemctl enable containerd.service

# Instalar docker compose v2
mkdir -p ~/.docker/cli-plugins/
COMPOSE_VERSION=$(curl -s https://github.com/docker/compose/releases/latest | egrep -o v[1-9]+.[1-9].[1-9/])
curl -SL https://github.com/docker/compose/releases/download/${COMPOSE_VERSION}/docker-compose-linux-x86_64 -o ~/.docker/cli-plugins/docker-compose
chmod +x ~/.docker/cli-plugins/docker-compose

reboot

#!/bin/bash

# Script que tenta automatizar (um pouco) a instalacao de pacotes e programas em um sistema Ubuntu (testado no Xubuntu mas deve funcionar igual)

# Atualizar sistema pos instalacao
sudo apt update -y
sudo apt upgrade -y

# vim/expect
sudo apt install -y vim
sudo apt install -y expect

# tmux (xubuntu nao vem instalado)
sudo apt install -y tmux

# git (xubuntu nao vem instalado)
sudo apt install -y git

# diff e merge tools
sudo apt install -y meld
sudo apt install -y kdiff3

git config --global diff.tool meld
git config --global merge.tool kdiff3
git config --global user.name "Eduardo Bortolatto Lopes"
git config --global user.email "eduardo.bortolatto@softplan.com.br"

# kubectl (k8s)
curl -LO "https://dl.k8s.io/release/v1.16.2/bin/linux/amd64/kubectl"
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
echo 'source <(kubectl completion bash)' >>~/.bashrc
rm kubectl

# neofetch (splash da config no terminal)
sudo apt install -y neofetch

# Docker & Docker compose (v2)
curl -fsSL https://get.docker.com -o get-docker.sh && sudo sh get-docker.sh 
sudo usermod -aG docker $USER
rm get-docker.sh

mkdir -p ~/.docker/cli-plugins/ 
COMPOSE_VERSION=$(curl -s https://github.com/docker/compose/releases/latest | egrep -o v[1-9]+.[1-9].[1-9/]) 
curl -SL https://github.com/docker/compose/releases/download/${COMPOSE_VERSION}/docker-compose-linux-x86_64 -o ~/.docker/cli-plugins/docker-compose 
chmod +x ~/.docker/cli-plugins/docker-compose

# openstack
sudo apt install -y ansible python3-openstacksdk rsync python3-openstackclient

# teams
sudo add-apt-repository 'deb https://packages.microsoft.com/repos/ms-teams stable main'
sudo apt update -y
sudo apt install -y teams

# sdkman
curl -s "https://get.sdkman.io" | bash
source "$HOME/.sdkman/bin/sdkman-init.sh"
sdk install java 11.0.13-ms

# dbeaver
wget -q https://dbeaver.io/files/dbeaver-ce_latest_amd64.deb
sudo dpkg -i dbeaver-ce_latest_amd64.deb

# flameshot
sudo apt install -y flameshot

# binários do postgres
sudo apt install -y postgresql-client-12

# RDP client
sudo apt install -y remmina

# jq (json processor)
sudo apt install -y jq

# kazam (gravação de tela)
sudo apt install -y kazam

# htop
sudo apt install -y htop

# httpie (https://httpie.io/cli)
sudo apt install -y httpie

# Forçar reinicialização do sistema
reboot

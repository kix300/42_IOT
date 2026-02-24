#!/bin/bash

GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}=== Début de l'installation des outils (Vagrant, K3s, K3d) ===${NC}"

sudo apt update && sudo apt install -y wget curl gnupg lsb-release

echo -e "\n${GREEN}[1/4] Installation de Vagrant...${NC}"
wget -O - https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt update && sudo apt install -y vagrant

echo -e "\n${GREEN}[2/4] Installation de K3s (Server)...${NC}"
curl -sfL https://get.k3s.io | sh -
sudo chmod 644 /etc/rancher/k3s/k3s.yaml

echo -e "\n${GREEN}[3/4] Installation de Docker...${NC}"
sudo apt update
sudo apt install ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

sudo tee /etc/apt/sources.list.d/docker.sources <<EOF
Types: deb
URIs: https://download.docker.com/linux/debian
Suites: $(. /etc/os-release && echo "$VERSION_CODENAME")
Components: stable
Signed-By: /etc/apt/keyrings/docker.asc
EOF

sudo apt update

sudo apt install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

sudo apt install -y libvirt qemu-system nfs-kernel-server qemu-utils libvirt-daemon-system libvirt-clients virt-manager \ libvirt-dev ruby-dev build-essential


sudo usermod -aG libvirt $USER 
sudo usermod -aG kvm $USER
newgrp libvirt

vagrant plugin install vagrant-libvirt

echo -e "\n${GREEN}[4/4] Installation de K3d...${NC}"
wget -q -O - https://raw.githubusercontent.com/k3d-io/k3d/main/install.sh | bash

echo -e "\n${BLUE}=== Installations terminées ! ===${NC}"
echo -e "Vagrant: $(vagrant --version)"
echo -e "K3d: $(k3d --version)"
echo -e "K3s: $(sudo k3s --version)"

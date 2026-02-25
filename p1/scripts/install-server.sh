#!/bin/bash 

apt-get update && apt-get install -y curl
systemctl stop ufw || true

IFACE=$(ip -4 ad | grep "192.168.56." | awk '{print $NF}')

curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC="server \
    --node-ip=192.168.56.110 \
    --advertise-address=192.168.56.110 \
    --bind-address=192.168.56.110 \
    --flannel-iface=$IFACE \
    --write-kubeconfig-mode 644" sh -

while [ ! -f /var/lib/rancher/k3s/server/node-token ]; do sleep 2; done
cp /var/lib/rancher/k3s/server/node-token /vagrant/k3s-token
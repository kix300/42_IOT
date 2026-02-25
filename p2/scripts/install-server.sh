#!/bin/bash 


apt-get update && apt-get install -y curl

IFACE=$(ip -4 ad | grep "192.168.56." | awk '{print $NF}')

curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC="server \
	--node-ip=192.168.56.110 \
	--advertise-address=192.168.56.110 \
	--bind-address=192.168.56.110 \
	--flannel-iface=$IFACE \
	--write-kubeconfig-mode 644" sh -
	until [ -f /etc/rancher/k3s/k3s.yaml ]; do sleep 2; done
	export KUBECONFIG=/etc/rancher/k3s/k3s.yaml
	until kubectl get node | grep -q "Ready"; do sleep 2; done

	if [ -f /vagrant/conf/k3s_config.yaml ]; then
		kubectl apply -f /vagrant/conf/k3s_config.yaml
	else
		echo "ERREUR : k3s_config.yaml non trouvé dans /vagrant/conf/"
	fi

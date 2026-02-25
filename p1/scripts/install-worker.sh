apt-get update && apt-get install -y curl
      
IFACE=$(ip -4 ad | grep "192.168.56." | awk '{print $NF}')

while [ ! -f /vagrant/k3s-token ]; do sleep 5; done

TOKEN=$(cat /vagrant/k3s-token)

curl -sfL https://get.k3s.io | K3S_URL=https://192.168.56.110:6443 \
K3S_TOKEN=$TOKEN \
INSTALL_K3S_EXEC="agent --node-ip=192.168.56.111 --flannel-iface=$IFACE" sh -
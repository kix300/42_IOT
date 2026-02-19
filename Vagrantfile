# -*- mode: ruby -*-
# vi: set ft=ruby :


Vagrant.configure("2") do |config|
  config.vm.box = "debian/bookworm64"

  config.vm.define "kdurouxS" do |s|
    s.vm.hostname = "kdurouxS"
    s.vm.network "private_network", ip: "192.168.56.110"
    
    s.vm.provider :libvirt do |v|
      # v.name = "kdurouxS"
      # use qemu without kvm (SLOW)
      v.driver = "qemu"
      v.cpu_mode = "host-passthrough"
      v.cpus = 1
      v.memory = 1024
      v.machine_type = "q35"
    end

    s.vm.provision "shell", inline: <<-SHELL
      curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC="--node-ip=192.168.56.110" sh -
      sudo cat /var/lib/rancher/k3s/server/node-token > /vagrant/token
    SHELL
  end

  config.vm.define "kdurouxSW" do |sw|
    sw.vm.hostname = "kdurouxSW"
    sw.vm.network "private_network", ip: "192.168.56.111"

    sw.vm.provider :libvirt do |v|
      # v.name = "kdurouxSW"
      v.driver = "qemu"
      v.cpu_mode = "host-passthrough"
      v.cpus = 1
      v.memory = 512
    end

    sw.vm.provision "shell", inline: <<-SHELL
      while [ ! -f /vagrant/token ]; do sleep 2; done
      TOKEN=$(cat /vagrant/token)
      curl -sfL https://get.k3s.io | K3S_URL=https://192.168.56.110:6443 K3S_TOKEN=$TOKEN INSTALL_K3S_EXEC="--node-ip=192.168.56.111" sh -
    SHELL
  end
end

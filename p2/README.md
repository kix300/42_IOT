# p2 : K3s and three simple applications

config of 3 app on k3s using nixos


### My idea 
- use nixos to reproductibilty
- conf k3s on .nix file
- conf nginx or other on .nix 
- ez pz 


### How to do 
- vagrant init nixbox/nixos --box-version 23.11
- vagrant plugin install vagrant-nixos-plugin

#### Some good link
- https://nixos.wiki/wiki/Vagrant_Box
- https://github.com/nix-community/nixbox
- https://github.com/nix-community/vagrant-nixos-plugin
- https://lunar.computer/vagrant-nixos
- https://github.com/traefik/whoami

#### UTILS
- sudo kubectl get pods 
- sudo kubectl get ingress

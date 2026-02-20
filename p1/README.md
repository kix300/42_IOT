# Part 1 : K3S et Vagrantfile

## Description

Ce projet met en place un cluster K3S minimal avec deux machines virtuelles provisionnées via Vagrant et libvirt/QEMU :

- **kdurouxS** : le nœud serveur (master) K3S
- **kdurouxSW** : le nœud worker K3S

## Prérequis

- Vagrant installé
- Plugin `vagrant-libvirt` installé
- QEMU/KVM disponible sur la machine hôte

## Architecture

| VM | Rôle | IP | CPU | RAM |
|---|---|---|---|---|
| kdurouxS | Server (master) | 192.168.56.110 | 1 | 1024 Mo |
| kdurouxSW | Worker | 192.168.56.111 | 1 | 512 Mo |

## Lancement

```bash
vagrant up
```

Les deux VMs se provisionnent automatiquement. Le serveur démarre en premier, génère son token K3S et le partage via `/vagrant/k3s-token`. Le worker attend ce token pour rejoindre le cluster.

## Vérification du cluster

Se connecter au serveur et vérifier que les nœuds sont bien enregistrés :

```bash
vagrant ssh kdurouxS
sudo kubectl get nodes
```

## Commandes utiles

```bash
# Logs du serveur K3S
sudo journalctl -u k3s -f

# Logs de l'agent K3S (worker)
sudo journalctl -u k3s-agent -f

# Statut du service sur le worker
sudo systemctl status k3s-agent
```

## Arrêt et nettoyage

```bash
vagrant halt     # Éteindre les VMs
vagrant destroy  # Supprimer les VMs
```

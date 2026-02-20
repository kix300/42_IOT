# IOT — Inception of Things

## Description

Projet d'infrastructure as code combinant Vagrant, K3S, K3D, Docker et Kubernetes pour déployer des environnements virtualisés légers.

## Stack technique

- **Vagrant** — provisionnement des VMs
- **QEMU / libvirt** — hyperviseur
- **K3S** — distribution Kubernetes légère pour VMs
- **K3D** — K3S dans Docker
- **Docker** — conteneurisation
- **K8S** — orchestration de conteneurs

## Structure du projet

```
.
├── install_tools.sh       # Script d'installation des dépendances
├── p1/                    # Part 1 — Cluster K3S avec Vagrant
├── p2/                    # Part 2 — (en cours)
├── p3/                    # Part 3 — (à venir)
└── bonus/                 # Bonus — (à venir)
```

## Progression

- [x] **Part 1** — Cluster K3S (server + worker) *(à tester)*
- [ ] **Part 2** — En cours
- [ ] **Part 3** — À venir
- [ ] **Bonus** — À venir

## Lancement

```bash
# Installer les dépendances
./install_tools.sh

# Démarrer les VMs
vagrant up
```

## Commandes utiles

```bash
# Statut global des VMs
vagrant global-status --prune

# Se connecter à une VM
vagrant ssh <hostname>

# Vérifier les nœuds K3S depuis le serveur
vagrant ssh kdurouxS -c "sudo kubectl get nodes"

# Redémarrer et reprovisionner une VM
vagrant reload kdurouxS --provision

# Supprimer toutes les VMs
vagrant destroy -f

# Supprimer les domaines libvirt manuellement
sudo virsh undefine p1_kdurouxS
sudo virsh undefine p1_kdurouxSW
sudo virsh list --all --managed-save
```

# Part 3: K3d and Argo CD (GitOps)

Ce projet met en place une infrastructure **GitOps** utilisant **K3d** (K3s dans Docker) et **Argo CD** pour déployer automatiquement une application depuis un dépôt GitHub.

## Prérequis
- Docker installé
- K3d installé
- Kubectl installé

## Installation Rapide

1. Clonez le dépôt sur votre VM.
2. À la racine du dossier `p3`, lancez :
   ```bash
   make

## Accès

- **Argo CD UI** : https://<IP_VM>:8443 (utilisez `make password` pour le mot de passe admin)
- **Application** : http://<IP_VM>:8888

Remplacez `<IP_VM>` par l'adresse IP de votre VM. Vos amis sur le même réseau peuvent y accéder directement.

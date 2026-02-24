GREEN  = \033[0;32m
YELLOW = \033[0;33m
NC     = \033[0m

.PHONY: up clean re status logs

up:
	@echo "$(GREEN)Démarrage des VMs avec Vagrant...$(NC)"
	vagrant up

clean:
	@echo "$(YELLOW)Destruction du cluster et nettoyage...$(NC)"
	vagrant destroy -f
	rm -f k3s-token
	# sudo virsh undefine p1_kdurouxS --remove-all-storage || true
	# sudo virsh undefine p1_kdurouxSW --remove-all-storage || true

re: clean up

status:
	@echo "$(GREEN)État des nœuds sur kdurouxS :$(NC)"
	vagrant ssh kdurouxS -c "sudo kubectl get nodes"

logs:
	@echo "$(YELLOW)Logs de l'agent k3s sur kdurouxSW (Ctrl+C pour quitter) :$(NC)"
	vagrant ssh kdurouxSW -c "sudo journalctl -u k3s-agent -f"

# Aide
help:
	@echo "Commandes disponibles :"
	@echo "  make up      - vagrant up"
	@echo "  make clean   - vagrant destroy + rm token"
	@echo "  make re      - Tout détruire et tout relancer"
	@echo "  make status  - Voir les nodes (kubectl get nodes)"
	@echo "  make logs    - Voir les logs de l'agent sur le worker"

CLUSTER_NAME = kdurouxC
GITLAB_NS = gitlab
ARGOCD_NS = argocd
DEV_NS = dev
ARGOCD_MANIFEST = https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
LOCAL_PORT = 8080
ARGOCD_SERVER = argocd-server

all: cluster namespaces argocd deploy deploy-gitlab password status

cluster:
	@echo "Creating k3d cluster..."
	@k3d cluster create $(CLUSTER_NAME) -p "8888:30080@loadbalancer" -p "8443:30081@loadbalancer" --agents 1
	@echo "Waiting for nodes to be ready..."
	@kubectl wait --for=condition=ready node --all --timeout=60s

namespaces:
	@echo "Creating namespaces..."
	@kubectl create namespace $(ARGOCD_NS) || true
	@kubectl create namespace $(DEV_NS) || true
	@kubectl create namespace $(GITLAB_NS) || true

deploy-gitlab:
	@echo "Applying GitLab Argo CD Application..."
	@kubectl apply -f gitlab-application.yaml -n $(ARGOCD_NS)
	@echo "Waiting for GitLab to sync..."
	@sleep 30
	@kubectl wait --for=condition=ready pod -l app.kubernetes.io/name=webservice -n $(GITLAB_NS) --timeout=600s || echo "GitLab peut prendre du temps à démarrer ; vérifie avec 'kubectl get pods -n gitlab'"

argocd:
	@echo "Installing Argo CD..."
	@kubectl apply -n $(ARGOCD_NS) -f $(ARGOCD_MANIFEST) --server-side
	@echo "Waiting for Argo CD server..."
	@kubectl wait --for=condition=ready pod -l app.kubernetes.io/name=argocd-server -n $(ARGOCD_NS) --timeout=300s
	@echo "Patching Argo CD server service to NodePort..."
	@kubectl patch svc argocd-server -n $(ARGOCD_NS) --type='json' -p='[{"op": "replace", "path": "/spec/type", "value": "NodePort"}, {"op": "replace", "path": "/spec/ports/0/nodePort", "value": 30081}]'

deploy:
	@echo "Applying Argo CD Application..."
	@kubectl apply -f application.yaml -n $(ARGOCD_NS)
	@echo "Waiting for app to sync..."
	@sleep 10
	@kubectl wait --for=condition=ready pod -l app=playground -n $(DEV_NS) --timeout=300s

password:
	@echo "\nArgo CD Initial Admin Password:"
	@kubectl -n $(ARGOCD_NS) get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d; echo

logs:
	@echo "Fetching logs from playground app..."
	@kubectl logs -n $(DEV_NS) -l app=playground --tail=20

status:
	@echo "\nCluster Status:"
	@kubectl get pods -A
	@echo "\nServices:"
	@kubectl get svc -n $(DEV_NS)
	@kubectl get svc -n $(GITLAB_NS)
	@echo "\nArgo CD Apps:"
	@kubectl get applications -n $(ARGOCD_NS)

clean:
	@echo "Deleting cluster..."
	@k3d cluster delete $(CLUSTER_NAME)


server:
	@echo "Setting up port-forward to ArgoCD server..."
	@echo "Access ArgoCD UI at: https://localhost:$(LOCAL_PORT)"
	@echo "Use 'make password' to get the admin password"
	@echo "Keep this terminal open - Press Ctrl+C to stop\n"
	@kubectl port-forward -n $(ARGOCD_NS) svc/$(ARGOCD_SERVER) $(LOCAL_PORT):443

access-guide:
	@echo "\nArgoCD Access Guide:"
	@echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
	@echo "Quick access (port-forward):"
	@echo "   $$ make server     # Start port-forward"
	@echo "   $$ make password   # Get password (in another terminal)"
	@echo "   Then visit: https://localhost:8080\n"
	@echo "External access (from same network):"
	@echo "   ArgoCD UI: https://<VM_IP>:8443"
	@echo "   App: http://<VM_IP>:8888"
	@echo "   Use 'make password' to get the admin password\n"
	@echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n"

re: clean all

.PHONY: all cluster namespaces argocd deploy deploy-gitlab password clean re logs status server access-guide

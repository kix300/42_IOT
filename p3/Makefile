# Variables
CLUSTER_NAME = kdurouxC
ARGOCD_NS = argocd
DEV_NS = dev
ARGOCD_MANIFEST = https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

all: cluster namespaces argocd deploy password status

cluster:
	@echo "Creating k3d cluster..."
	@k3d cluster create $(CLUSTER_NAME) -p "8888:30080@loadbalancer" --agents 1
	@echo "Waiting for nodes to be ready..."
	@kubectl wait --for=condition=ready node --all --timeout=60s

namespaces:
	@echo "Creating namespaces..."
	@kubectl create namespace $(ARGOCD_NS) || true
	@kubectl create namespace $(DEV_NS) || true

argocd:
	@echo "Installing Argo CD..."
	@kubectl apply -n $(ARGOCD_NS) -f $(ARGOCD_MANIFEST) --server-side
	@echo "Waiting for Argo CD server..."
	@kubectl wait --for=condition=ready pod -l app.kubernetes.io/name=argocd-server -n $(ARGOCD_NS) --timeout=300s

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
	@echo "\nArgo CD Apps:"
	@kubectl get applications -n $(ARGOCD_NS)

clean:
	@echo "Deleting cluster..."
	@k3d cluster delete $(CLUSTER_NAME)

re: clean all

.PHONY: all cluster namespaces argocd deploy password clean re logs status

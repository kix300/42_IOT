# Variables
CLUSTER_NAME = kdurouxC
ARGOCD_NS = argocd
DEV_NS = dev
ARGOCD_MANIFEST = https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

all: cluster namespaces argocd application password

cluster:
	@echo "Creating k3d cluster..."
	@k3d cluster create $(CLUSTER_NAME) -p "8888:30080@agent:0" --agents 1

namespaces:
	@echo "Creating namespaces..."
	@kubectl create namespace $(ARGOCD_NS)
	@kubectl create namespace $(DEV_NS)

argocd:
	@echo "Installing Argo CD..."
	@kubectl apply -n $(ARGOCD_NS) -f $(ARGOCD_MANIFEST) --server-side
	@echo "Waiting for Argo CD pods to be ready..."
	@kubectl wait --for=condition=ready pod -l app.kubernetes.io/name=argocd-server -n $(ARGOCD_NS) --timeout=300s

application:
	@echo "Applying Argo CD Application..."
	@kubectl apply -f application.yaml -n $(ARGOCD_NS)

password:
	@echo "\nArgo CD Initial Admin Password:"
	@kubectl -n $(ARGOCD_NS) get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d; echo

clean:
	@echo "Deleting cluster..."
	@k3d cluster delete $(CLUSTER_NAME)

re: clean all

.PHONY: all cluster namespaces argocd application password clean re

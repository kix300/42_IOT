CLUSTER_NAME = kdurouxC
GITLAB_NS = gitlab
ARGOCD_NS = argocd
ARGOCD_MANIFEST = https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
LOCAL_PORT = 8080
ARGOCD_SERVER = argocd-server

all: cluster namespaces argocd deploy-gitlab password status

cluster:
	@echo "Creating k3d cluster..."
	@k3d cluster create $(CLUSTER_NAME) -p "8888:30080@loadbalancer" -p "8443:30081@loadbalancer" -p "80:30080@loadbalancer" -p "443:30081@loadbalancer" --agents 1 --servers-memory 5G --agents-memory 5G
	@echo "Waiting for nodes to be ready..."
	@kubectl wait --for=condition=ready node --all --timeout=60s

namespaces:
	@echo "Creating namespaces..."
	@kubectl create namespace $(ARGOCD_NS) || true
	@kubectl create namespace $(GITLAB_NS) || true

deploy-gitlab:
	./scripts/deploy-gitlab.sh

argocd:
	./scripts/argocd.sh

password:
	@echo "\nArgo CD Initial Admin Password:"
	@kubectl -n $(ARGOCD_NS) get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d; echo
	@kubectl -n $(GITLAB_NS) get secret gitlab-gitlab-initial-root-password -o go-template='{{.data.password}}' | base64 -d && echo

status:
	@echo "\nCluster Status:"
	@kubectl get pods -A
	@echo "\nServices:"
	@kubectl get svc -n $(GITLAB_NS)
	@echo "\nGitLab Ingresses:"
	@kubectl get ingress -n $(GITLAB_NS)
	@echo "\nArgo CD Apps:"
	@kubectl get applications -n $(ARGOCD_NS)

clean:
	@echo "Deleting cluster..."
	@k3d cluster delete $(CLUSTER_NAME)



re: clean all

.PHONY: all cluster namespaces argocd deploy-gitlab password clean re status

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
	@echo "Installing GitLab via Helm (following https://faun.pub/deploy-gitlab-in-on-premises-kubernetes-1833ef599f80)..."
	@helm repo add gitlab https://charts.gitlab.io/ || true
	@helm repo update
	@helm upgrade --install gitlab gitlab/gitlab --namespace $(GITLAB_NS) --timeout 600s --set global.hosts.domain=kixlab.com --set global.hosts.https=false --set global.ingress.configureCertmanager=false -f value.yaml
	@echo "Patching GitLab nginx-ingress-controller to NodePort..."
	@kubectl patch svc gitlab-nginx-ingress-controller -p '{"spec": {"type": "NodePort"}}' -n $(GITLAB_NS)
	@kubectl patch svc gitlab-nginx-ingress-controller -p '{"spec": {"externalTrafficPolicy": "Cluster"}}' -n $(GITLAB_NS)
	#utilise le port 30080
	@kubectl patch svc gitlab-nginx-ingress-controller -n gitlab --type='json' -p='[{"op": "replace", "path": "/spec/ports/0/nodePort", "value": 30080}]'
	@echo "Waiting for GitLab pods to be ready..."
	@kubectl wait --for=condition=ready pod -l app.kubernetes.io/name=webservice -n $(GITLAB_NS) --timeout=600s || echo "GitLab peut prendre 10-15 min à démarrer ; vérifie avec 'kubectl get pods -n gitlab'"
	@echo "\nGitLab Ports (check with 'kubectl describe svc gitlab-nginx-ingress-controller -n gitlab'):"
	@kubectl describe svc gitlab-nginx-ingress-controller -n $(GITLAB_NS) | grep -E "Port:|NodePort:"
	@echo "\nGitLab Root Password:"
	@kubectl -n $(GITLAB_NS) get secret gitlab-gitlab-initial-root-password -o go-template='{{.data.password}}' | base64 -d && echo

argocd:
	@echo "Installing Argo CD..."
	@kubectl apply -n $(ARGOCD_NS) -f $(ARGOCD_MANIFEST) --server-side
	@echo "Waiting for Argo CD server..."
	@kubectl wait --for=condition=available deployment/argocd-server -n $(ARGOCD_NS) --timeout=300s
	@echo "Patching Argo CD server service to NodePort..."
	@kubectl patch svc argocd-server -n $(ARGOCD_NS) --type='json' -p='[{"op": "replace", "path": "/spec/type", "value": "NodePort"}, {"op": "replace", "path": "/spec/ports/0/nodePort", "value": 30081}]'

password:
	@echo "\nArgo CD Initial Admin Password:"
	@kubectl -n $(ARGOCD_NS) get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d; echo
	@kubectl -n $(GITLAB_NS) get secret gitlab-gitlab-initial-root-password -o go-template='{{.data.password}}' | base64 -d && echo

logs:
	@echo "Fetching logs from playground app..."
	@kubectl logs -n $(DEV_NS) -l app=playground --tail=20

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


server:
	@kubectl port-forward -n gitlab svc/gitlab-nginx-ingress-controller 8080:80

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

.PHONY: all cluster namespaces argocd deploy-gitlab password clean re logs status server access-guide

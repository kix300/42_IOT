#!/bin/bash

GITLAB_NS=gitlab

echo "Installing GitLab via Helm..."
helm repo add gitlab https://charts.gitlab.io/ || true
helm repo update
helm upgrade --install gitlab gitlab/gitlab \
  --namespace $GITLAB_NS \
  --timeout 600s \
  --set global.hosts.domain=kixlab.com \
  --set global.hosts.https=false \
  --set global.ingress.configureCertmanager=false \
  -f value.yaml

echo "Patching GitLab nginx-ingress-controller to NodePort..."
kubectl patch svc gitlab-nginx-ingress-controller -p '{"spec": {"type": "NodePort"}}' -n $GITLAB_NS
kubectl patch svc gitlab-nginx-ingress-controller -p '{"spec": {"externalTrafficPolicy": "Cluster"}}' -n $GITLAB_NS

# utilise le port 30080
kubectl patch svc gitlab-nginx-ingress-controller -n $GITLAB_NS --type='json' \
  -p='[{"op": "replace", "path": "/spec/ports/0/nodePort", "value": 30080}]'

echo "Waiting for GitLab pods to be ready..."
kubectl wait --for=condition=ready pod -l app.kubernetes.io/name=webservice \
  -n $GITLAB_NS --timeout=600s \
  || echo "GitLab peut prendre 10-15 min à démarrer ; vérifie avec 'kubectl get pods -n gitlab'"

echo "GitLab Ports:"
kubectl describe svc gitlab-nginx-ingress-controller -n $GITLAB_NS | grep -E "Port:|NodePort:"

echo "GitLab Root Password:"
kubectl -n $GITLAB_NS get secret gitlab-gitlab-initial-root-password \
  -o go-template='{{.data.password}}' | base64 -d && echo

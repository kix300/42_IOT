#!/bin/bash

ARGOCD_NS=argocd
ARGOCD_MANIFEST=https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

echo "Installing Argo CD..."
kubectl apply -n $ARGOCD_NS -f $ARGOCD_MANIFEST --server-side

echo "Waiting for Argo CD server..."
kubectl wait --for=condition=available deployment/argocd-server -n $ARGOCD_NS --timeout=300s

echo "Patching Argo CD server service to NodePort..."
kubectl patch svc argocd-server -n $ARGOCD_NS --type='json' \
  -p='[{"op": "replace", "path": "/spec/type", "value": "NodePort"}, {"op": "replace", "path": "/spec/ports/0/nodePort", "value": 30081}]'

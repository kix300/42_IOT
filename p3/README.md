# p3: k3d and argocd

#### UTILS
- k3d cluster create mycluster -p "8888:30080@agent:0" --agents 1

- kubectl create namespace argocd
- kubectl create namespace dev
- kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml --server-side
- kubectl apply -f p3/application.yaml -n argocd

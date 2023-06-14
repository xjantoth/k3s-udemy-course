#!/bin/bash

# sudo cat /var/lib/cloud/instance/scripts/part-001
# cat /var/log/cloud-init-output.log
# https://austindewey.com/2020/10/16/configure-ec2-the-cloud-native-way-using-aws-parameter-store/

set -ex

echo "K3S Master: Hello User Data from Terraform" > /opt/user_data.txt

sudo apt update
sudo apt install awscli -y

curl -sfL https://get.k3s.io | sh -s - --write-kubeconfig-mode 644 --tls-san $(curl ifconfig.me) --disable servicelb --disable traefik
export KUBECONFIG=/etc/rancher/k3s/k3s.yaml

c=0
max=60

until [[ "$(curl -k -s -o /dev/null -w '%{http_code}' https://$(curl -s http://169.254.169.254/latest/meta-data/public-ipv4):6443/healthz)" == "401" ]];  do
  echo "Waiting for Kubernetes API to be available..."
  ((c++))
  if [[ ${c} -ge ${max} ]]; then
    exit 1
  fi
  sleep 5
done

# TODO: user parameter for region
aws ssm put-parameter --name "k3s_token" \
  --value "$(sudo cat /var/lib/rancher/k3s/server/node-token)" \
  --type "String" --overwrite \
  --region us-east-1



# Install helm binary
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
chmod 700 get_helm.sh
./get_helm.sh

echo 'source <(kubectl completion bash)' >>~/.bashrc
echo 'alias k=kubectl' >>~/.bashrc
echo 'complete -F __start_kubectl k' >>~/.bashrc

echo 'source <(kubectl completion bash)' >>/home/ubuntu/.bashrc
echo 'alias k=kubectl' >>/home/ubuntu/.bashrc
echo 'complete -F __start_kubectl k' >>/home/ubuntu/.bashrc
source ~/.bashrc

helm repo add nginx https://kubernetes.github.io/ingress-nginx
helm repo update nginx
helm install nginx nginx/ingress-nginx --set controller.service.nodePorts.http=30111

kubectl create deployment k3scourse --image=ghcr.io/benc-uk/python-demoapp:latest --replicas=1 --port 5000
kubectl expose deployment k3scourse --port=8080 --target-port=5000 # --type NodePort

# TODO: wait until Nginx Ingress Controller available
kubectl apply -f - <<EOF
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: k3scourse
spec:
  ingressClassName: nginx
  rules:
    - http:
        paths:
          - pathType: Prefix
            path: /
            backend:
              service:
                name: k3scourse
                port:
                  number: 8080
EOF


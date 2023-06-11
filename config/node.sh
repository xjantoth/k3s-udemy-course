#!/bin/bash

# sudo cat /var/lib/cloud/instance/scripts/part-001
# cat /var/log/cloud-init-output.log

set -ex

echo "K3S Node: Hello User Data from Terraform" > /opt/user_data.txt


#curl -sfL https://get.k3s.io | sh -s - --write-kubeconfig-mode 644 --tls-san $(curl ifconfig.me)
# TODO
# 
curl -sfL https://get.k3s.io | K3S_URL=https://${MASTER_PRIVATE_IPV4}:6443 K3S_TOKEN=${K3S_TOKEN} sh -
export KUBECONFIG=/etc/rancher/k3s/k3s.yaml

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


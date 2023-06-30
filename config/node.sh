#!/bin/bash

# sudo cat /var/lib/cloud/instance/scripts/part-001
# cat /var/log/cloud-init-output.log

echo "K3S Node: Hello User Data from Terraform" > /opt/user_data.txt

apt update
apt install awscli -y

c=0
max=60

until [[ "$(curl -k -sL -I https://${MASTER_PRIVATE_IPV4}:6443/healthz | head -n1)" == *"HTTP/2 401"* ]];  do
  echo "Waiting for Kubernetes API to be available..."
  ((c++))
  if [[ $c -ge $max ]]; then
    exit 1
  fi
  sleep 5
done


count=0
retries=30

until [[ "$(aws ssm get-parameters --names k3s_token --query 'Parameters[0].Value' --output text --region ${REGION})" != "empty" ]]; do
  ((count++))
  if [[ $count -ge $retries ]]; then
    echo "Could not get a proper K3S token"
    exit 0
  fi
  sleep 10
done

export K3S_TOKEN_SSM="$(aws ssm get-parameters --names k3s_token --query 'Parameters[0].Value' --output text --region ${REGION})"
curl -sfL https://get.k3s.io | K3S_URL=https://${MASTER_PRIVATE_IPV4}:6443 K3S_TOKEN=$K3S_TOKEN_SSM sh -

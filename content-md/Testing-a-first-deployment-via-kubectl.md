### Testing a simple Kubernetes deployment via kubectl and a bit of Helm


```bash

ssh -i ~/.ssh/k3s-course ubuntu@3.92.203.125


source <(kubectl completion bash)
alias k=kubectl
complete -F __start_kubectl k

echo -e "
source <(kubectl completion bash)
alias k=kubectl
complete -F __start_kubectl k" >> /home/ubuntu/.bashrc

source ~/.bashrc

# Install helm binary
export KUBECONFIG=/etc/rancher/k3s/k3s.yaml
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 && chmod 700 get_helm.sh
./get_helm.sh

helm repo add nginx https://kubernetes.github.io/ingress-nginx
helm repo update nginx
helm install nginx nginx/ingress-nginx --set controller.service.nodePorts.http=30111


# Dry run for Kubernetes deployment
ubuntu@ip-172-31-93-88:~$ kubectl create deployment k3scourse --image=ghcr.io/benc-uk/python-demoapp:latest --replicas=1 --port 5000 --dry-run=client -o yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  creationTimestamp: null
  labels:
    app: k3scourse
  name: k3scourse
spec:
  replicas: 1
  selector:
    matchLabels:
      app: k3scourse
  strategy: {}
  template:
    metadata:
      creationTimestamp: null
      labels:
        app: k3scourse
    spec:
      containers:
      - image: ghcr.io/benc-uk/python-demoapp:latest
        name: python-demoapp
        ports:
        - containerPort: 5000
        resources: {}
status: {}



kubectl create deployment k3scourse --image=ghcr.io/benc-uk/python-demoapp:latest --replicas=1 --port 5000

# Dry run for Kubernetes service
ubuntu@ip-172-31-93-88:~$ kubectl expose deployment k3scourse --port=8080 --target-port=5000 --dry-run=client -o yaml
apiVersion: v1
kind: Service
metadata:
  creationTimestamp: null
  labels:
    app: k3scourse
  name: k3scourse
spec:
  ports:
  - port: 8080
    protocol: TCP
    targetPort: 5000
  selector:
    app: k3scourse
status:
  loadBalancer: {}

kubectl expose deployment k3scourse --port=8080 --target-port=5000 # --type NodePort

# TODO: wait until Nginx Ingress Controller available
export cc=0
export maxx=60

# Waiting for Nginx Ingress Controller deployment to be available
until [[ "$(kubectl get deployments.apps nginx-ingress-nginx-controller -o jsonpath={.status.readyReplicas})" == "1" ]];  do
  echo "Waiting for Nginx Ingress Controller to be available..."
  ((cc++))
  if [[ $cc -ge $maxx ]]; then
    "I had to exit waiting for Nginx Ingress Controller"
    exit 0
  fi
  sleep 5
done

# Creating Ingress for a demo app
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

```


#### Test that security group allows only port specified via telnet or netcat(nc) commnad

```bash
# run this command at EC3 instance in AWS
nc -l -p 10333

# run this commands locally
telnet 1.2.3.4 10333
telnet 1.2.3.4 80

nc -z -v -w2 1.2.3.4 10333
nc -z -v -w2 1.2.3.4 80
```

#### Network settings within a running container

```bash
k exec -it k3scourse-974775499-9jbfm -- bash
k get pods -o wide

awk '/32 host/ { print f } {f=$2}' <<< "$(</proc/net/fib_trie)"
```


#### Scale Kubernetes Deployment

```bash
ubuntu@ip-172-31-93-88:~$ k scale deployment k3scourse --replicas 10
deployment.apps/k3scourse scaled
ubuntu@ip-172-31-93-88:~$ k get pods
NAME                                              READY   STATUS              RESTARTS   AGE
k3scourse-974775499-9jbfm                         1/1     Running             0          16m
nginx-ingress-nginx-controller-7848578667-dw9zg   1/1     Running             0          13m
k3scourse-974775499-fjsc7                         0/1     ContainerCreating   0          3s
k3scourse-974775499-fhjz8                         0/1     ContainerCreating   0          3s
k3scourse-974775499-8mnrj                         0/1     ContainerCreating   0          3s
k3scourse-974775499-pzr7k                         0/1     ContainerCreating   0          3s
k3scourse-974775499-l46rw                         0/1     ContainerCreating   0          3s
k3scourse-974775499-q845b                         1/1     Running             0          3s
k3scourse-974775499-5qx7t                         1/1     Running             0          3s
k3scourse-974775499-nwqmf                         1/1     Running             0          3s
k3scourse-974775499-kfs7b                         1/1     Running             0          3s

```



#### Destroy your AWS infrastructure

Destroy your infrastructure to avoid unneceassary expenxes

```bash
export AWS_DEFAULT_PROFILE=k3s-restrictive-no-mfa
cd terraform/
terraform destroy

```

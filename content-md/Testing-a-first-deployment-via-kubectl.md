### Testing a first deployment via kubectl

```bash
kubectl create deployment k3scourse --image=ghcr.io/benc-uk/python-demoapp:latest --replicas=1 --port 5000
kubectl expose deployment k3scourse --port=8080 --target-port=5000 # --type NodePort

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


helm repo add nginx https://kubernetes.github.io/ingress-nginx
helm repo update nginx
helm install nginx nginx/ingress-nginx --set controller.service.nodePorts.http=30111
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

awk '/32 host/ { print f } {f=$2}' <<< "$(</proc/net/fib_trie)"
```

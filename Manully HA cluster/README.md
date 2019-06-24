## Create a HA kubernetes cluster

### HAProxy
```
sudo add-apt-repository ppa:vbernat/haproxy-1.8
sudo apt-get update
sudo apt-get install haproxy

sudo vi /etc/haproxy/haproxy.cfg and add config using haproxy.cfg reference config file.
```

### Install kubectl, kubelet and kubeadm into the servers (masters and workers).
```
sudo apt-get update && sudo apt-get install -y apt-transport-https
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee -a /etc/apt/sources.list.d/kubernetes.list
sudo apt-get update
sudo apt-get install -y kubectl
```

ssh to master1

Add the following configuration.
```
$ vi /etc/kubernetes/kubeadm/kubeadm-config.yaml
apiVersion: kubeadm.k8s.io/v1beta1
kind: ClusterConfiguration
kubernetesVersion: stable
# REPLACE with `loadbalancer` IP
controlPlaneEndpoint: "xx.xx.xx.xx:6443"
networking:
  podSubnet: 10.244.0.0/16


kubeadm init \
    --config=/etc/kubernetes/kubeadm/kubeadm-config.yaml \
    --experimental-upload-certs
```	

To start using your cluster, you need to run the following as a regular user:
```
  mkdir -p $HOME/.kube
  sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
  sudo chown $(id -u):$(id -g) $HOME/.kube/config
```


You should now deploy a pod network to the cluster.
Run "kubectl apply -f [podnetwork].yaml" with one of the options listed at:
  https://kubernetes.io/docs/concepts/cluster-administration/addons/

```
Networking:

Canal: 
kubectl apply -f https://docs.projectcalico.org/v3.7/manifests/canal.yaml

```


### You can now join any number of the control-plane node running the following command on each as root:
```
  kubeadm join xx.xx.xx.xx:6443 --token 5do643.uga7j9kncdqo5hcs \
    --discovery-token-ca-cert-hash sha256:eb7f357edca65c3049a40d97171ab83eb01918cde55310fede6517752349e5fc \
    --experimental-control-plane --certificate-key 47c8356114f94b1ff481eae469a58086757c168c90b636859e9a7a3a5071170b
```

Please note that the certificate-key gives access to cluster sensitive data, keep it secret!
As a safeguard, uploaded-certs will be deleted in two hours; If necessary, you can use
"kubeadm init phase upload-certs --experimental-upload-certs" to reload certs afterward.

```
Then you can join any number of worker nodes by running the following on each as root:

kubeadm join xx.xx.xx.xx:6443 --token 5do643.uga7j9kmcdro5hcs \
    --discovery-token-ca-cert-hash sha256:eb7f357edca65e5049a40d97171ab83eb34918dbe55310fede6517750449e5fc
```


### HELM Install:
```
curl -L https://git.io/get_helm.sh | bash
kubectl apply -f https://raw.githubusercontent.com/kc004/kubernetes-test/master/Manully%20HA%20cluster/helm-rbac.yaml
helm init --service-account tiller
```	

### Nginx ingress:
```
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/master/deploy/static/mandatory.yaml
```
### Heapster for metrics:
```
https://raw.githubusercontent.com/kc004/kubernetes-test/master/Heapster/heapster-deployment.yaml
https://raw.githubusercontent.com/kc004/kubernetes-test/master/Heapster/heapster-rbac.yaml
https://raw.githubusercontent.com/kc004/kubernetes-test/master/Heapster/influxdb.yaml
```

### Kubernetes Dashboard:
```
kubectl apply -f https://raw.githubusercontent.com/kc004/kubernetes-test/master/Manully%20HA%20cluster/kube-dashboard-rbac.yaml
kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/master/aio/deploy/recommended/kubernetes-dashboard.yaml

UI Token:
kubectl -n kube-system describe secret $(kubectl -n kube-system get secret | grep admin-user | awk '{print $1}')	
```

### Storage:
```
Longhorn:
prerequisite: sudo apt-get install open-iscsi
Deployment: kubectl apply -f https://raw.githubusercontent.com/rancher/longhorn/master/deploy/longhorn.yaml
Storage class: kubectl create -f https://raw.githubusercontent.com/rancher/longhorn/master/examples/storageclass.yaml
```

### Jenkins install:
```
helm install --name jenkins stable/jenkins --namespace jenkins --set master.serviceType=NodePort
password:  printf $(kubectl get secret --namespace jenkins jenkins -o jsonpath="{.data.jenkins-admin-password}" | base64 --decode);echo
```

### Private Docker Registry
```
mkdir auth
docker run --entrypoint htpasswd registry:2 -Bbn username password > auth/htpasswd
docker container stop registry
docker run -d -p 5000:5000 --restart=always --name registry-docker -v "$(pwd)"/auth:/auth -e "REGISTRY_AUTH=htpasswd" -e "REGISTRY_AUTH_HTPASSWD_REALM=Registry Realm" -e REGISTRY_AUTH_HTPASSWD_PATH=/auth/htpasswd -v "$(pwd)"/certs:/certs -e REGISTRY_HTTP_TLS_CERTIFICATE=/certs/domain.crt -e REGISTRY_HTTP_TLS_KEY=/certs/domain.key registry:2
```

### Mediawiki:
```
helm install --name mediawiki --namespace mediawiki stable/mediawiki --set mediawikiEmail=user@gmail.com
```

### Istio:
```
helm repo add istio.io https://storage.googleapis.com/istio-release/releases/1.2.0/charts/

kubectl create namespace istio-system

curl -L https://git.io/getLatestIstio | ISTIO_VERSION=1.2.0 sh -
cd istio-1.2.0

helm install install/kubernetes/helm/istio-init --name istio-init --namespace istio-system

helm template install/kubernetes/helm/istio --name istio --namespace istio-system \
    --values install/kubernetes/helm/istio/values-istio-demo.yaml | kubectl apply -f -
```
### Monitoring (Prometheus, Alert-manager and Grafana)
```
helm install --name prometheus --namespace prometheus stable/prometheus-operator
```

### Horitzontal Pod Autoscaler (HPA)
```
ref: kubectl apply -f https://raw.githubusercontent.com/kc004/kubernetes-test/master/Manully%20HA%20cluster/HPA.yaml
```

### Backup Script:
```
kubectl apply -f https://raw.githubusercontent.com/kc004/kubernetes-test/master/Manully%20HA%20cluster/backup-script.sh
```

### Tear down kubernetes cluster:
```
kubectl apply -f https://raw.githubusercontent.com/kc004/kubernetes-test/master/Manully%20HA%20cluster/tear-down.sh
```

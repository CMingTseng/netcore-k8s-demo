# Minikube installation
```
# Based on https://github.com/kubernetes/minikube/releases
version=0.17.1
curl -Lo /tmp/minikube https://storage.googleapis.com/minikube/releases/v${version}/minikube-linux-amd64 && chmod +x /tmp/minikube && sudo mv /tmp/minikube /usr/local/bin/
```



# kubectl installatiom
```
echo See http://kubernetes.io/docs/user-guide/prereqs/
cd /tmp
curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt
curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl
chmod +x kubectl
sudo mv kubectl /usr/local/bin/
cd -

kubectl version
```



# Start minikube
```
# Get latest version from
minikube get-k8s-versions

# Will use default which is virtualbox
version=1.6.0
minikube start --kubernetes-version $version -v 10 | tee minikube-start.log
minikube cluster-info
```



# Start dashboard
```
kubectl create -f https://rawgit.com/kubernetes/dashboard/master/src/deploy/kubernetes-dashboard.yaml
# This will block acting as a proxy with security credentials to access the k8s cluster dashboard - will beed to append the /ui/ suffix to see the dashboard
kubectl proxy
```



# Start first service version instance
- Assumes you have already build the docker images and pushed to dockerhub (Public)

```
# Create namespace and pods
namespace='dev'
kubectl create -f ./00-namespace.yaml
kubectl create -f ./01-webapi-deployment.yaml --namespace $namespace

# Query
# Pod ls
kubectl get pods --namespace $namespace
# Our pod
pod_name=$(kubectl get pods --selector 'app==webapi' --namespace $namespace --output 'jsonpath={.items[0].metadata.name}')
kubectl logs $pod_name --namespace $namespace --follow
kubectl logs $pod_name --namespace $namespace --follow --tail 100
kubectl describe po/$pod_name --namespace $namespace

# Now start service
kubectl create -f 02-webapi-service.yaml --namespace $namespace
kubectl get services --namespace $namespace
minikube service webapi --url --namespace $namespace

# Show all resources
kubectl get all --namespace $namespace

# Show all resources in all namespaces
kubectl get all --all-namespaces
```



# Start using the service - ideally so we could see side by side with alterations - watch the hostName value
```
service_url=$(minikube service webapi --url --namespace $namespace)
while [ true ]; do date; curl -s -w '\n\n' ${service_url}/environment; sleep 1; done
```
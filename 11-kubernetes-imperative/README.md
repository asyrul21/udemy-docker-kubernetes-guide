# Deploy on Kubernetes

```bash
# build image and publish to registry
docker build -t user/kub-first-app .
docker login
docker push user/kub-first-app
docker logout

# check if Kubernetes Cluster is up
minikube status

# if stopped, start
minikube start --driver=docker
# or
minikube start --driver=virtualbox
# for windows
minkuber start --driver=hyperv

#
# Create Deployment Object in Kubernetes Cluster
#
kubectl create deployment first-app --image=user/kub-first-app
# check if success
kubectl get deployments
# READY column should be 1/1
kubectl get pods
# STATUS column should be `Running`

#
# Expose Deployment to External access
#
kubectl expose deployment first-app --type=LoadBalancer --port=8080
# check
kubectl get services
# you should see a new LoadBalancer service is created
# EXTERNAL IP will be populated if you run on Cloud
# If you run using minkube, EXTERNAL IP will be <pending>

#
# get service IP running on Minikube virtual machine
#
minikube service first-app

#
# Scale the Pod
#
kubectl scale deployment/first-app --replicas=3
# check
kubectl get pods

#
# Updating the Code
#
# You must rebuild the image and push to DockerHub/repod
kubectl set image deployment/first-app kub-first-app=user/kub-first-app:2
# you will get this message:
# deployment.apps/first-app image updated
#
# check
kubectl rollout status deployment/first-app
# you will get:
# deployment "first-app" successfully rolled out
```

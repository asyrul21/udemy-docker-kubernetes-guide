# Run

```bash
# create deployment
kubectl apply -f=deployment.yaml
# you will get:
# deployment.apps/second-app-deployment created

# check
kubectl get deployments

# create service
kubectl apply -f=service.yaml
# you will get:
# service/backend-service created

# check
kubectl get services
minikube service backend-service

# using the merged config
kubectl apply -f=merged-deployment.yaml
```

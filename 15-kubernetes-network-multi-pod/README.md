# Run

```bash
# dev
docker-compose up -d --build

# build and publish users image
cd users-api/
docker build -t user/kub-demo-users .
docker push user/kub-demo-users

# apply users
kubectl apply -f=users-deployment.yaml
kubectl apply -f=users-service.yaml

# test
minikube service users-service

# build and publish auth image
cd auth-api/
docker build -t user/kub-demo-auth .
docker push user/kub-demo-auth

# apply auth
kubectl apply -f=auth-deployment.yaml -f=auth-service.yaml
#
# get Internal Cluster IP Address
#
kubectl get services
# it will be in the ClusterIP Column
#
# OR
#
# use automatically generated kubernetes global variable:
# AUTH_SERVICE_SERVICE_HOST

# build and publish tasks image
cd auth-api/
docker build -t user/kub-demo-tasks .
docker push user/kub-demo-tasks

# apply tasks
kubectl apply -f=tasks-deployment.yaml -f=tasks-service.yaml

# build and publish frontend image
cd frontend/
docker build -t user/kub-demo-frontend .
# test front end image locally
docker run -p 80:80 --rm -d user/kub-demo-frontend
# publish
docker push user/kub-demo-frontend

# apply frontend
kubectl apply -f=frontend-deployment.yaml -f=frontend-service.yaml

minikube service frontend-service
```

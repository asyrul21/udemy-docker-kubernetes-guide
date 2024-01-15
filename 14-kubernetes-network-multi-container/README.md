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
```

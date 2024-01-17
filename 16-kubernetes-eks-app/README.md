# Run

```bash
# build users, auth, and tasks
cd users-api/
docker build -t user/kub-eks-users .
docker push user/kub-eks-users

cd auth-api
docker build -t  user/kub-eks-auth .
docker push user/kub-eks-auth

cd tasks-api/
docker build -t user/kub-eks-tasks .
docker push user/kub-eks-tasks

#
# Setup all your AWS EKS stuff and link to local kubectl
#

# apply
cd kubernetes/
kubectl apply -f=auth.yaml -f=users.yaml -f=tasks.yaml

# delete and re-apply to update
cd kubernetes/
kubectl delete deployment auth-deployment
kubectl delete deployment users-deployment
kubectl delete deployment tasks-deployment
```

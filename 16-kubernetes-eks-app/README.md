# Run

```bash
# build users and auth
cd users-api/
docker build -t user/kub-eks-users .
docker push user/kub-eks-users

cd auth-api
docker build -t  user/kub-eks-auth .
docker push user/kub-eks-auth

#
# Setup all your AWS EKS stuff and link to local kubectl
#

# apply
cd kubernetes/
kubectl apply -f=auth.yaml -f=users.yaml

```

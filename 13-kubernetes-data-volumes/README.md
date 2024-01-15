# Run

```bash
# dev
docker-compose up -d --build

## build the image
docker build -t user/kub-volumes-demo:latest .

## push to docker HUb
docker login
docker push user/kub-volumes-demo
docker logout

# check minkube is running
minikube status

# apply objects
kubectl apply -f=environment.yaml
kubectl apply -f=host-pv.yaml
kubectl apply -f=host-pv-claim.yaml
kubectl apply -f=service.yaml -f=deployment.yaml
```

# Run

1. Use bind mounts on `docker run` cli arguments.

```bash
# build image
docker build -t myUser/node-example-app-1 .

# push to DockerHub
docker login
docker push
docker logout

# on remote
docker run -d --rm -p 80:80 myUser/node-example-app-1

# to update the image to latest version
docker pull myUser/node-example-app-1

docker run -d --rm --name node-example-app -p 80:80 node-example
```

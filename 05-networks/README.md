# Run

```bash
docker network create fav-net

# docker run -d -p 27017:27017 --name mongo-db --network fav-net mongo
# -p only needed if require access from localhost
docker run -d --name mongo-db --network fav-net mongo

docker build -t favourites-node .

docker run --name favourites-app -d --rm -p 3000:3000 --network fav-net favourites-node
```

# Finding out the IP Address of a Container

```bash
docker inspect mongo-db
```

See under Networks > IPAddress

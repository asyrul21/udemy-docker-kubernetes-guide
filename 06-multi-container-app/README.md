# Run

```bash
# create network
docker network create goals-net

# dockerize mongo
# docker run --name mongo-db --rm -d -p 27017:27017 mongo
# -p only needed if require access from localhost ie. your  backend is not dockerized
docker run --name mongo-db --rm -d -v local-mongo-data:/data/db --network goals-net -e MONGO_INITDB_ROOT_USERNAME=myUser -e MONGO_INITDB_ROOT_PASSWORD=myPassword mongo

# dockerize backend
cd ./backend
docker build -t goals-node .
#
# run backend container
docker run --name goals-backend --rm -d -p 80:80 --network goals-net -v logs:/app/logs -v /app/node_modules -v $(pwd):/app -e MONGODB_USERNAME=myUser -e MONGODB_PASSWORD=myPassword goals-node

# dockerize React frontend
cd ./frontend
docker build -t goals-react .
#
# run frontend - MUST have -it flag
# docker run --name goals-frontend --rm -it -p 3000:3000 --network goals-net goals-react
#
# WE DONT NEED NETWORK, BECAUSE REACT FRONTEND ONLY RUNS
# ON LOCAL HOST MACHINE WEB BROWSER. IT DOES NOT COMMUNICATE WITH OTHER
# CONTAINERS PER SE
#
docker run --name goals-frontend --rm -it -p 3000:3000 -v /Users/asyrulhafetzy/Documents/Development/Udemy_Courses/docker_kubernetes_guide/06-multi-container-app/frontend/src:/app/src goals-react
```

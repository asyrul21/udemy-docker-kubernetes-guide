# Docker & Kubernetes Guide

Based on [Docker & Kubernetes: The Practical Guide](https://www.udemy.com/course/docker-kubernetes-the-practical-guide) Udemy Course.

[Docker Online Playground](https://labs.play-with-docker.com/)

[Docker Hub](https://hub.docker.com/)

# Help

```bash
docker --help

docker [command] --help
# docker run --help
```

# Docker Images & Containers

2 Ways to use Image:

1. Pull published images from Docker Hub

2. Create your own image using Dockerfile

Image name conversion:

[name of image]:[version or tag]

## Commands

### Manage

```bash
# view all running containers
docker ps

# view all running and stopped containers
docker ps -a

# view images
docker images

# inspect
docker image inspect [IMAGE ID]

# getting a container's IP Address for cross-container communication
docker image inpsect mongo-db
# See under Networks > IPAddress

```

### Build Image

```bash
docker build [path]
# docker build .

# custom Dockerfile file name
docker build -f [dockerfile name] [path]
# docker build -f myDockerFile .

# giving Tag or Name
docker build -t [name or tag] [path]
# docker build -t myapp:latest .

#####
# BUILD Args
#####
# overriding build args defined in Dockrfile
docker build --build-arg DEFAULT_PORT=80 .
```

### Run

Creates a New container.

Important Concepts:

1. [Anonymous vs Named vs Bind Mount Volumes](https://www.udemy.com/course/docker-kubernetes-the-practical-guide/learn/lecture/22166924#questions/13807296)

2. [Environment Variabled vs Build Arguments](https://www.udemy.com/course/docker-kubernetes-the-practical-guide/learn/lecture/22166940#questions/13807296)

In commands below, [image] means the `IMAGE ID` (partial ID also works) or `NAME` of either a LOCALLY built image or PUBLISHED image.

```bash
#####
# run image in a container
#####
docker run [image]
#
# Spin Up a MongoDB container without a Dockerfile
docker run -d --name mongo-db mongo

#####
# exposing port
#####
docker run -p [host port:container exposed port] [image]
# docker run -p 3000:3000 c10b910dd

#####
# detached mode
#####
docker run -d [image]

#####
# running published image on Docker Hub
#####
# docker run node

#####
# run and enter interactive shell of container
#####
# docker run -it node

#####
# Automatically deletes the container exits or stopped
#####
docker run --rm [image]

#####
# Giving a name
#####
docker run --name [custom_name] [image]

#####
# Named Volume Default (No Bind Mounting)
#####
docker run -v [volume name]:[container folder path] [image]
# docker run -v myVolume:/app/feedback m

#####
# [ENABLE HOT RELOAD] Named Volume Bind Mounting / Bind Mount
#####
# Prefer to use double quotes
# IMPORTANT - using -v will override COPY-ed files as defined in Dockerfile.
# Add anonymous volumes with a more specific path accordingly to prevent the override
docker run -v "[host folder ABSOLUTE path]:[container folder path]" [image]
docker run -v $(pwd):[container folder path] [image]
# docker run -v /my/absolute/path/app/:/app/ myImage
# combining bind mounts with anonymous volume:
docker run -v /my/absolute/path/app:/app -v /app/node_modules myImage
# shortcut to absolute path:
docker run -v $(pwd):/app myImage -v /app/node_modules myImage
# enforce read only for host machine:
docker run -v "/my/absolute/path/app:/app:ro" myImage

#####
# ENVIRONMENT VARIABLES
####
docker run --env [variable]=[value] [id or name of published image]
# docker run --env PORT=80 myImage
# docker run --env PORT=80 --env URL=test.com myImage
# docker run --e PORT=80 myImage

# using an Environment Variable File
# More secure
docker run --env-file ./.env [image]


#####
# Network: IMPORTANT: YOU MUST CREATE A NETWORK FIRST
#####
docker run --network my_network [image]
# docker run --network fav-net mongo
```

### Start or Restart Stopped Containers

Important concepts:

1. Attached (runs in foreground) / detached (runs in background). [Lecture](https://www.udemy.com/course/docker-kubernetes-the-practical-guide/learn/lecture/22166826#overview)

```bash
# find stopped containers
docker ps -a

# start
# detached by default
docker start [id or name of container]

# start but attach to container
docker start -a [id or name of container]

# reattach to a detached running container
docker attach [id or name of container]
```

### Stop

```bash
# stop container
docker stop [container name]
# docker stop vibrant_gates
```

### Removing / Deleting

Cannot delete a running container. Stop it first.

1. Removing Containers

```bash
# view
docker ps

docker rm [id or container name(s)]
# docker rm container1 container2 container3
```

2. Removing Images

Cannot delete image being used by containers, even if stopped Containers. Remove the Container first.

```bash
# deletes image and all its layers
docker rmi [IMAGE ID(s)]
# docker rmi 123 234 345

# delete all images not being used by running Containers
docker image prune

# delete all including tagged images
docker image prune -a

# prune force
docker image prune -f
```

### Logging

```bash
docker logs [id or name of container]

# follow mode (attach)
docker logs -f [id or name of container]
```

### Copy Files

1. From host to container

2. From container to host

```bash
# copy from host to container
docker cp [path of host file(s) / source] [container_name]:[path in container]

# copy all files in a folder
# docker cp testFolder/. sample_container:/test

# copy specific file
# docker cp testFolder/.test.txt sample_container:/test

# copy from container to host
docker cp [container_name]:[path in container] [path of host file(s) / source]
```

### Volumes (Managed By Docker)

Manage volumes created by docker.

3 typs of volumes:

1. Anonymous

   - will be deleted automatically when container is removed

   - will not work with `docker run --rm` flag

2. Named

   - survives `--rm` and container removal

   - can be shared across containers

3. Bind Mounts

LONGER AND MORE SPECIFIC CONTAINER PATHS HAVE PRECEDENCE AND OVERRIDES SHORTER PATH

```bash
docker volume --help

docker volume ls

# deleting or removing unused volumes
docker volume rm [volume name]
# OR
docker volume prune

# create
docker volume create [volume name]

# inspect
docker volume inspect [volume name]
```

### Network

```bash
docker network --help

# create
docker network create [name]
# docker network create fav-net

# list
docker network ls
```

### History

```bash
dockr history [id or name if image]
```

## Docker Image File

1. Order is important

2. Important concepts: Image Layers, How Docker Caches Dockerfile Commands: [Lecture](https://www.udemy.com/course/docker-kubernetes-the-practical-guide/learn/lecture/22166800#overview)

```dockerfile
#####
# FROM [name of image either locally or published]
#####
FROM node

#####
# BUILD ARGUMENTS
#####
ARG DEFAULT_PORT=80

#####
# WORKDIR [directory]
# - where all the other commands will be run at
# default is /
#####
WORKDIR /app

#####
# COPY [host/source dir path] [container dir path]
#####
# COPY . .
COPY package.json /app

#####
# RUN [command] # usually for image setup
#####
# should always run npm install before COPY
RUN npm install

# COPY [host/source dir path] [container dir path]
# use .dockerignore to restrict what gets copied
# COPY . .
COPY . /app

#####
# Setting Environment variable
#####
ENV PORT=80
# OR
# use --env flag when running. SEE #Run
#
# environment variables defined in `docker run` (SEE #Run) will override
# the one in Dockerfile
#
# referencing BUILD ARGS
# ENV PORT=$DEFAULT_PORT
#
# OVERRIDE DEFAULT in build: SEE #Build

# expose the port so it can be access from Host machine
# still need port mapping flag in [docker run -p 80:80]
# EXPOSE 80
# using ENV variable:
EXPOSE $PORT

#####
# Volumes
#####
# format
# Anonymous Volume - [ "{directory path in container}" ]
VOLUME [ "/app/node_modules" ]
# OR
# Use Named Volume in run command. SEE #Run

#####
# CMD [command array] # usually for spinning up the image
#####
CMD ["node", "server.js"]
```

## Sharing Images

### Authenticate

```bash
docker login

docker logout
```

### Sharing / Pushing to Docker Hub

1. You need to login before pushing

2. Name of local image must match the Repository created in DockerHub

```bash
# build image with correct name
docker build -t myUsername/docker-course-app .

# OR Rename an image

docker tag [old name with tag] [new name and tag]

# Push
# docker push [username]/[repository]:[image tag]

docker push [image name : tag] # image name must match repo name
# docker push myUsername/docker-course-app:latest
```

### Pulling / Downloading Images

1. If repo is private, you need to Log In

```bash
docker pull [image repository]
```

## Networks

3 Cases:

1. Calling external WWW services - works out of the box in container

2. Calling services running on Host Machine from within a container.

   - Does not work out of the box

   - Replace `localhost` with `host.docker.internal`

   - example, replace: `mongodb://localhost:27017/swfavourites`

     with

     `mongodb://host.docker.internal:27017/swfavourites`

3. Cross-Container Communication. See [section](#cross-container-communication).

### Cross Container Communication

2 ways to achieve this.

1. Use IP Address of Containers

   - inspect the container `docker inspect mongo-db`

   - check the IP Address at Networks > IPAddress

   - Replace `localhost` with the IP Address of the container

   - example, replace: `mongodb://localhost:27017/swfavourites`

     with

     `mongodb://172.17.0.2:27017/swfavourites`

2. Docker Networks

   - put related containers into a network

   - IMPORTANT: Create a network first. See [docker network command](#network)

   - use the `--network` flag during `docker run`. See [Run](#run).

   - Replace `localhost` with the NAME of container

   - example, replace: `mongodb://localhost:27017/swfavourites`

     with

     `mongodb://mongo-db:27017/swfavourites`

# Docker Compose

# Kubernetes

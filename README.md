# Docker & Kubernetes Guide

Based on [Docker & Kubernetes: The Practical Guide](https://www.udemy.com/course/docker-kubernetes-the-practical-guide) Udemy Course.

[Docker Online Playground](https://labs.play-with-docker.com/)

[Docker Hub](https://hub.docker.com/)

# Check Docker Version

You can use this command to check if Docker is already installed.

```bash
docker version
```

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

Important Concepts:

1. [Anonymous vs Named vs Bind Mount Volumes](https://www.udemy.com/course/docker-kubernetes-the-practical-guide/learn/lecture/22166924#questions/13807296)

2. [Environment Variabled vs Build Arguments](https://www.udemy.com/course/docker-kubernetes-the-practical-guide/learn/lecture/22166940#questions/13807296)

3. [Multi-Stage Build](https://www.udemy.com/course/docker-kubernetes-the-practical-guide/learn/lecture/22626687#questions/13731474)

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

#####
# Multi Stage Builds
#####
# target specific build stage
docker build --target [stage name] .
docker build --target build .
```

### Run

Creates a New container.

In commands below, [image] means the `IMAGE ID` (partial ID also works) or `NAME` of either a LOCALLY built image or PUBLISHED image.

```bash
#####
# run image in a container
#####
docker run [image]
# docker run -it node
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

#####
# Overriding an image's CMD command:
#####
docker run -it [image] [CMD Command]
# docker run -it node npm init
```

### Exec

SSH into or run a specific command in a container.

You must provide the `-it` flag.

```bash
# run a specific command
docker exec -it [container] [command]
#
# overriding published image's default CMD coammnd:
# docker run -it node npm init
# SEE #Run

# SSH into a container
docker exec -it [container]
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

#####
# ENTRYPOINT: Append all commands passed in `docker run` with `npm`
#####
ENTRYPOINT ["npm"]
```

For Example of Multi-Stage Build Dockerfile, see `10-multi-container-deployment/frontend/prod.Dockerfile`

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

   - For React or Front End containers, you can NOT reference container names. You have to use `localhost`. This is because front-end codes run in the client's browser, and not in the container. For this reason, your backend service would need to expose its port.

# Docker Compose

1. Docker compose does NOT replace Dockerfiles

2. Each service must still have its own Dockerfile

3. By default all containers started with `--rm` aka removed when stopped.

4. `network` is usually automatically configured. So do not need to create new network and define in `docker-compose.yml`

## Commands

### Build

Just build and not start the containers.

```bash
docker-compose build
```

### Start

Builds and runs containers.

```bash
docker-compose up --help

docker-compose up

# detached mode
docker-compose up -d

# docker compose specific services
docker-compose up [service1] [service1] ...

# force images rebuilt on up
docker-compose up --build
```

### Stop and Remove

```bash
docker-compose down

# remove volumes also (not common practice)
docker-compose down -v
```

### Exec

```bash
docker-compose exec
```

### Run

Enables running a specific service and override its CMD command.

```bash
docker-compose run [service name] [CMD Command]
# docker-compose run mynpm init

# remove container when stopped
docker-compose run --rm [service name] [CMD Command]
docker-compose run --rm mynpm init
```

## Docker Compose File

[Official Reference](https://docs.docker.com/compose/compose-file/compose-file-v3/)

```yml
# Docker Compose Version
version: "3.8"

services:
   # [service name]:
   #      cofigs
   mongodb:
      #
      # image
      #
      # can be local image name, or published image or URL
      image: "mongo"
      #
      # volume
      #
      # if using Named Volume, must create `volumes` object next to `services`. See below.
      #
      volumes:
      # - data:/data/db
      #
      # make readonly
      #
      # - "mongo-db-data":/data/db:ro
      #
      # make delegated
      # ./src:/var/www/html:delegated
      #
      - "mongo-db-data":/data/db
      #
      # force container name (OPTIONAL)
      #
      container_name: mongodb
      #
      # environment
      #
      environment:
      #
      # alternative format (no dash, with colon):
      # MONGO_INITDB_ROOT_USERNAME: myUser
      #
      # - MONGO_INITDB_ROOT_USERNAME=myUser
      # - MONGO_INITDB_ROOT_PASSWORD=myPassword
      #
      - MY_VAR=Hello World
      #
      # use file - see `env_file:`
      env_file:
      - ./env/mongo.env
      #
      # networks (OPTIONAL)
      #
      # usually configured automatically by docker-compose
      networks:
      - goals-net

  backend:
      #
      # build
      #
      # build an image based on path of Dockerfile
      #  build: ./backend
      #
      # alternative syntax:
      #
      # allows custom Dockerfile file name
      #
      build:
         context: ./backend
         dockerfile: Dockerfile
         #
         # build arguments
         #
         args:
         #  some arg: some value
      #
      # PORTS
      #
      ports:
         - '80:80'
      #
      # Volumes
      #
      volumes:
         #
         # Named Volume
         #
         # Named Volumes must be added to `volumes` object next to `services`
         #
         - logs:/app/logs
         #
         # Bind Mounts - use RELATIVE PATHS
         #
         - ./backend:/app
         #
         # Anonymous volume
         #
         - /app/node_modules

      #
      # environment
      #
      env_file:
         - ./env/backend.env
      #
      # depends on:
      #     - [service name]
      #
      depends_on:
         - mongodb
      #
      # Entrypoint: Override or ADD a Dockerfile or Image's entrypoint
      #
      entrypoint: ["php", "/var/www/html/artisan"]
      #
      # working_dir: Override or ADD a Dockerfile or Image's WORKDIR
      #
      working_dir: /app

  frontend:
      build: ./frontend
      ports:
         - '3000:3000'
      volumes:
         - ./frontend/src:/app/src
      #
      # Interactive Mode
      #
      stdin_open: true
      tty: true
      #
      #
      depends_on:
      - backend
volumes:
  data:
  logs:
```

## Deployment of Docker Image App to AWS

Always do bind mounts with `docker run` cli arguments. We do not need Bind Mounts in Production.

General Steps:

1. [Create an Remote Server](#creating-an-aws-ec-2-server)

2. [SSH into it](#ssh-into-aws-ec2-server) and [Install Docker](#install-docker-on-aws-ec2-server)

3. [Push your image to a Cloud Repo / DockerHub](#sharing-images)

4. Run your published image:

```bash
docker run -d --rm -p 80:80 [published-image]
# docker run -d --rm -p 80:80 myUser/my-app
```

5. [Configure EC2 Security](#configure-aws-ec2-security-groups)

6. [Grab the server address](#find-aws-ec2-address-url)

7. Test on your browser by navigating to the URL:

```
http://13.250.5.253/
```

NOTE: the `http` instead of `HTTPS`. HTTPS wont work. HTTPS requires certificates configuration.

## Deployment of Docker Compose App to AWS

# AWS

[Read Best Practices](https://docs.aws.amazon.com/AmazonECS/latest/bestpracticesguide/application.html)

## Manually Managed Remote Servers with EC2

### Creating an AWS EC-2 Server

1. Go to AWS > EC2 > Launch Instance Button

2. Configure the Remote Server and create a Key Pair and Store that key-pair. This key-pair file will be needed everytime we connect to the remote server.

3. Click Launch

### SSH into AWS EC2 Server

1. In AWS Dashboard > All Instances > Click Connect

2. Navigate to SSH Client. Over there, you will find instructions:

   1. Open an SSH client.

   2. Locate your private key file. The key used to launch this instance is docker-course.pem

   3. Run this command, if necessary, to ensure your key is not publicly viewable.

   ```bash
   # navigate to the key-pair folder
   cd keys

   # change permission
   chmod 400 "docker-course_key_pair.pem"
   ```

   4. Connect to your instance using its Public DNS:
      ec2-13-250-5-253.ap-southeast-1.compute.amazonaws.com

   ```bash
   # navigate to the key-pair folder
   cd keys

   ssh -i "docker-course_key_pair.pem" ec2-user@ec2-13-250-5-253.ap-southeast-1.compute.amazonaws.com
   ```

### Install Docker on AWS EC2 Server

1. [SSH into the Remote Server](#ssh-into-aws-ec2-server)

2. Run Some Commands:

```bash
sudo yum update -y

sudo yum -y install docker

sudo service docker start

sudo usermod -a -G docker ec2-user
```

3. Log Out

```bash
exit
```

4. SSH Into It Again

5. Enable docker

```bash
sudo systemctl enable docker
```

6. Check if docker is installed

```
docker version
```

### Find AWS EC2 Address URL

1. Go to AWS > EC2 > Instances

2. Look for column `IPv4 Address`

## Configure AWS EC2 Security Groups

1. Go to AWS > EC2 > Instances > Click You Instance

2. In the `Security` tab, see the Security Group, and click.

3. Under `Inbound` tab. Click `Edit Inbound Rules`

4. Add Rule > Type: `HTTP`, Source: `Anywhere IPv4`

Network & Security > Security Groups

## Shutdown EC2 Instance

1. Go to AWS > Instances > Actions > Instance State > Terminate

## Managed Remote Servers with ECS (Elastic Container Service)

Designed for Docker containers.

Automatically updates and scaling simplified.

Supports Auto Scaling.

Not Free.

[View Lecture](https://www.udemy.com/course/docker-kubernetes-the-practical-guide/learn/lecture/22626535#questions)

[View Answer for Updated AWS UI](https://www.udemy.com/course/docker-kubernetes-the-practical-guide/learn/lecture/22626535#questions/19146302)

General Steps:

1. [Create and Configure ECS](#create-and-configure-ecs-cluster-tasks-and-services)

2. [Configure Security Group](#configure-ecs-instance-security-group)

3. [Get the URL](#finding-the-ecs-address-url)

4. Test on your browser by navigating to the URL:

```
http://13.214.189.42/
```

NOTE: the `http` instead of `HTTPS`. HTTPS wont work. HTTPS requires certificates configuration.

### Create and Configure ECS Cluster, Tasks, and Services

1. Go to AWS > ECS > Create a Cluster

2. Go to AWS > ECS > Task Definitions > Create New Task Definition

3. Click your task, then Deploy > Create Service

   - Give the service a name

   - assign the cluster to the one you created in (1)

### Create Target Group

1. Go to AWS > EC2 > Target Groups > Create Target Group

2. Choose Type: IP

### Create an Application Load Balancer (ALB)

1. [Create a IP Target Group](#create-target-group)

2. Go to AWS > ECS > Load Balancer > Create Application Load Balancer

3. In `Listeners and Routing`, add the target group you created in (1)

4. You can access the Load Balancer URL by going to Load Balancers > select your Load Balancer. In the `Details` tab, see `DNS Name`. Example:

```
goals-fe-lb-1581441734.ap-southeast-1.elb.amazonaws.com
```

### Configure ECS Instance Security Group

1. Go to AWS > ECS > Clusters > Select your cluster > Click your Service

2. In the `Tasks` tab, Click on the Task ID

3. In the `Networking` tab, click the `Security Groups`

4. Click Edit Inbound Rules

5. Edit the Inbound rules: Type:HTTP, source: anywhereIPv4

### Finding the ECS Address URL

1. Go to AWS > ECS > Clusters > Select your cluster > Click your Service

2. In the `Tasks` tab, Click on the Task ID

3. The URL should be at the `Configuration` tab > Public IP

### Updating Image Version in ECS

1. Build and Push your latest image version

2. On AWS, Go to `Task Definitions` > Select your task > Create New Task Revision

3. Actions > Update Service

### Deleting ECS Service

1. Go to AWs > ECS > Clusters

2. In the `Services` tab, select your service and click `Delete Service`

## Multi-Container Docker Compose Deployment with AWS ECS

General Steps:

1. Create a Cluster. Please refer [Create and Configure ECS Cluster](#create-and-configure-ecs-cluster-tasks-and-services).

2. Go to Task Definitions > Create New Task Definition.

   - Set `Task Role` to `ecsTaskExecutionRole`

3. ADD a container for Backend.

   - In `Docker Configuration` tab override the local CMD (if it is using nodemon for eg.) by providing `node app.js` in the `Command` field

   - Set Your environment variables.

   - Note that in ECS, cross-container communication is done via `localhost`. So replace

   ```javascript
   `mongodb://user:pass@mongodb:27017/course-goals?authSource=admin`;
   ```

   with

   ```javascript
   `mongodb://user:pass@localhost:27017/course-goals?authSource=admin`,
   ```

   Better still, use env:

   ```
   `mongodb://${process.env.MONGODB_USERNAME}:${process.env.MONGODB_PASSWORD}@${MONGODB_URL}:27017/course-goals?authSource=admin`,
   ```

   - Define your `Startup Dependency Ordering` - similar to `depends_on`

4. ADD a Container for MongoDB.

   - Add your enviornment variables

   - configure ECS volumes: Under `Storage` > `Volumes`,`Add Volume`. Name: data, Type:EFS

   - Create new NFS security group

   - Go to EFS AMAZON CONSOLE and create a new EFS File System. See [Lecture](https://www.udemy.com/course/docker-kubernetes-the-practical-guide/learn/lecture/22626625#questions/18762324). In Network Access tab, use the NFS Security Group you created above.

   - In Storage > Volume 1 > Add Mount Point. Select your Volume, and set Container Path:/data/db

   - NOTE: It is always better to use a Managed Database Service - MongoDB Atlas, AWS RDS, etc. If you do, replace your `mongoose.connect` connection string accordingly.

5. Repeat steps 3 - 5 to add other containers.

6. Go to Clusters > Select your Cluster > Create a service. Refer [here](#create-and-configure-ecs-cluster-tasks-and-services)

- Launch Type: select `FARGATE`

- Task Definition: Select your Task created in Steps 2-5.

- Check in `Network` type and select a VPC. Then add all subnets.

- Load Balancer: Choose `Application Load Balancer`

7. [Configure Security Group](#configure-ecs-instance-security-group)

8. [Get the URL](#finding-the-ecs-address-url)

9. Test on your browser by navigating to the URL:

```
http://13.214.189.42/
```

NOTE: the `http` instead of `HTTPS`. HTTPS wont work. HTTPS requires certificates configuration.

### Creating a New AWS Task For React Frontend

NOTE: You cannot implement multiple Web Servers in one Task, due to conflicting ports etc. Best Practice is for eack Task to have exactly ONE web server.

[Lecture](https://www.udemy.com/course/docker-kubernetes-the-practical-guide/learn/lecture/22626711#questions)

1. In the same cluster, go to Task Definitions > Create a New Task Definition

   - Set `Task Role` to `ecsTaskExecutionRole`

2. ADD a Container for React.

   - Need to implement Multi-Stage Build. See example Dockerfile in `10-multi-container-deployment/frontend/prod/dockerfile`

   - Change your api accordingly. Replace:

     ```javascript
     const response = await fetch("http://localhost/goals");
     ```

     with

     ```javascript
     const response = await fetch("http://x.x.x.x/goals");
     ```

     NOTE: You can use the IP, but it changes on every deploy. Create an Application Load Balancer instead, and point to your Backend Service. Then you can use the ALB's DNS Name. See [Creating An ALB](#create-an-application-load-balancer-alb)

   - Add Exposed Port Mapping: 80 or whichever PORT you exposed.

3. Create the Task, then Create a Service

# Kubernetes

General Concepts:

1. Pods

- One or more Application Containers and their Resources (Volumes, IP, configs etc)

- Usually, 1 Container per Pod

- Created and managed by K8s

- Usually not created and managed manually. We use `Deployment Object` which creates, controls, and manages Pods.

2. Service

- A service groups PODS together, and gives them a shared IP

- Allows external access to Pods

3. Worker Nodes

- Similar remote machine concept

- Usually Docker is installed here

- One or more Pods

- Has `Kubelet` to manage communication with Master Node

- Has `Kube-Proxy` to manage network communication between Node and Pod

4. Master Node

- Manage Worker Nodes with The Control Plane

- Runs `API Server` for `kubelets` to communicate.

- Has `Scheduler` that watches for new Pods and selects Worker Nodes to run them on

- `Kube-Controller-Manager`

- `Cloud-Controller-Manager`

5. Cluster

- A Collection of Node Machines (Master Node + Worker Nodes)

6. `kubectl` to send intructions to the Cluster.

## Setup Mini Cluster Locally using [Minikube](https://minikube.sigs.k8s.io/docs/start/)

### On MacOS

You must have `VirtualBox` already installed.

1. Install `kubectl` using Homebrew

```bash
brew install kubectl

kubectl version --client
```

2. Install Minikube - Kubernetes Playground environment

```bash
brew install minikube
```

3. Start Minikube

```bash
minikube start --driver=virtualbox
# OR
minikube start --driver=docker
# for Windows
minikube start --driver=hyperv
```

4. Stop Minikube

```bash
minikube stop
```

Check status:

```bash
minikube status

minikube dashboard
```

## kubectl Commands (Imperative)

### Help

```bash
kubectl --help

kubectl [command] --help
# kubectl create --help
```

### View

````bash
# deployments
kubectl get deployments
# pods
kubectl get pods
# get services
kubectl get services
# get storage classes
kubectl get sc
# get persistent volumes
kubectl get pv
# get persistent volume claims
kubectl get pvc
# get config map
kubectl get configmap
# get namespaces
kubectl get namespaces

### Create

```bash

# Create a New Deployment Object
# Sends a docker image to the Kubernetes Cluster aka the Master Node and Control Plane
kubectl create deployment [name] --image=[published image registry]
# kubectl create deployment first-app --image=user/kub-first-app

# Create a service
kubectl create service
````

### Expose

Automatically creates a Service to contain the Pod.

Types of expose:

1. ClusterIP - default - internal only
2. NodePort
3. LoadBalancer

```bash
# Create a service for the pod and expose it to external access
kubectl expose deployment [deployment name] --type=[expose type] --port=[exposed port]
# kubectl expose deployment first-app --type=LoadBalancer --port=8080
```

### Scale

```bash
kubectl scale [deployment or service]/[deployment app] --replicas=3
# kubectl scale deployment/first-app --replicas=3

# check
kubectl get pods
```

### Set

Update a specific deployment with an updated Image.

You need to find the Pod's Container Name:

1. On `minikube dashboard`, got to Pods > Click on Your Pod

2. Scroll down and under `Containers`, you will se the container name.

IMPORTANT: The image will only be updated in the Pod if the new image has a different tag.

```bash
kubectl set image [deployment or service]/[deployment name]  [pod container name]=[registry]
# kubectl set image deployment/first-app kub-first-app=user/kub-first-app:2

# you will get this message:
# deployment.apps/first-app image updated

# check
kubectl rollout status deployment/first-app
```

### Rollout

```bash
#
# Get rollout (POD Update) status.
#
kubectl rollout status [deployment or service]/[deployment name]
# kubectl rollout status deployment/first-app

#
# Rollback / Undo Rollout / Pod Update
#
kubectl rollout undo [deployment or service]/[deployment name]
# rollback to specific revision version
kubectl rollout undo [deployment or service]/[deployment name] --to-revision
# kubectl rollout undo deployment/first-app
# kubectl rollout undo deployment/first-app --to-revision=1

# View Rollout History
kubectl rollout history [deployment or service]/[deployment name]
# kubectl rollout history deployment/first-app
kubectl rollout history [deployment or service]/[deployment name] --revision=[revision number]
# kubectl rollout history deployment/first-app --revision=1
```

### Delete

```bash
# delete deployment
kubectl delete deployment [name]

# delete service
kubectl delete service [name]

# delete using a config yaml file
kubctl delete -f=[filename]
# kubectl delete -f=deployment.yaml
# kubectl delete -f=service.yaml
# delete multiple
# kubectl delete -f=deployment.yaml,service.yml
# OR
# kubectl delete -f=deployment.yaml -f=service.yaml
```

### Apply

Use a config file to apply conifiguration commands to create Deployment or Service Objects.

If you update any of your yaml files, simplu run `apply` again to reflect those changes.

```bash
kubectl apply -f=[config file]
# kubectl apply -f=deployment.yaml
# kubectl apply -f=service.yaml
```

### Force Update A Deployment to User Latest Image

If you made changes to the `deployments.yaml` file, you can simple run `kubectl apply -f=deployment.yaml`

However, if you did not change the `deployments.yaml`, and your image has been updated, first delete the deployment:

```bash
cd kubernetes/ # your folder
kubectl delete -f=deployment.yaml
```

Then re apply with `kubectl apply -f=deployment.yaml`

## Kubernetes Config Files (Declarative)

### Deployment Object

[Official API Reference](https://kubernetes.io/docs/reference/kubernetes-api/workload-resources/deployment-v1/)

[Volume Types](https://kubernetes.io/docs/concepts/storage/volumes/)

```yaml
#
# Kubernetes Deployment API version
#
apiVersion: app/v1
#
# kind - what do you wan to create
#
kind: Deployment
#
# metadata: to give your deployment a name, etc
#
metadata:
  name: second-app-deployment
#
# spec: the specification to add Pods and Containers
#
spec:
  #
  # replicas: no. of pod instances (scaling)
  #
  replicas: 1
  #
  # Selector: a required field
  #
  selector:
   #
   # match labels - bind/connect pods with this Deployment Object.
   # By using labels you created in template.metadata.labels
   #
   matchLabels:
      app: second-app
      tier: backend
   # more complex labels
   # matchExpressions:
   #    - {key: app, operator: In, values: [second-app, first-app]}
  #
  # template: template or image for Pod
  #
  template:
    #
    # template metadata
    #
    metadata:
      #
      # labels - can have one or more labels
      #
      labels:
        app: second-app
        tier: backend
    #
    # specification of pod
    #
    spec:
      #
      # Define container(s). Every Pod can have multiple containers
      #
      containers:
         #
         # container name
         #
         - name: second-node
         #
         # published image: auto update if provide :latest
         #
         image: user/kub-first-app:2
         #
         # imagePullPolicy: Always or Never or ..
         #
         imagePullPolicy: Always
         #
         # livenessProbe (optional): how to check pod health
         #
         livenessProbe:
            httpGet:
               path: /
               port: 8080
            periodSeconds: 3
            initialDelaySeconds: 5
         #
         # Environment Variables
         #
         env:
            -  name: STORY_FOLDER
               value: story
            #
            # using configMap:
            #
            -  name: STORY_FOLDER
               valueFrom:
                  #
                  # the key of data defined in your ConfigMap
                  #
                  configMapKeyRef:
                     #
                     # name: name of your configMap
                     #
                     name: data-store-env
                     #
                     # key: the key name of the variable
                     #
                     key: folder
         #
         # VOLUME BINDING - declare top level volumes first
         #
         volumeMounts:
            #
            # mountPath: internal container path of directory which you
            # would like to persist.
            # Check your Dockerfile WORKDIR
            #
            -  mountPath: /app/story
               #
               # name: pointing to volume you defined at top level
               #
               name: story-volume
         #
         #
         # - name: third-container
         #    image: sample-image
      #
      # VOLUMES
      #
      volumes:
         -  name: story-volume
            #
            # use the Volume Type as key
            #
            # using emptyDir:
            #
            # emptyDir: {}
            #
            # OR: Using hostPath
            #
            # hostPath:
            #    #
            #    # path of the host machine to bind
            #    #
            #    path: /data
            #    #
            #    # type: how path is handled
            #    #
            #    type: DirectoryOrCreate
            #
            # OR: Claim a Persistent Volume
            #
            persistentVolumeClaim:
               #
               # claimName: name of the Persistent Volume Claim you defined
               #
               claimName: host-pvc
```

### Service Object

Service is needed mainly for:

1. Stable IP Address

2. Potentially exposing the Pod to external communication

[Official API Reference](https://kubernetes.io/docs/reference/kubernetes-api/service-resources/service-v1/)

```yaml
#
# Kubernetes Service API version
#
apiVersion: v1
#
# kind - what do you wan to create
#
kind: Service
#
# metadata: to give your service a name, etc
#
metadata:
  name: backend-service
#
# spec: the specification to connect your Service to your PODS
#
spec:
  #
  # selector: to select your pods using the labels
  # you deifned in Deployment.
  #
  # You do NOT need to select ALL labels.
  #
  selector:
    app: second-app
    #  tier: backend
   #
   # PORTS: ports configuration. Can have multiple.
   #
   ports:
      - protocol: 'TCP'
         #
         # host port
         #
         port: 80
         #
         # internal / cluster port
         #
         targetPort: 8080
      # - protocol: 'TCP'
      #   port: 443
      #   targetPort: 443
   #
   # Service Type: ClusterIP or NodePort or LoadBalancer
   #
   # use ClusterIP for internal communication only
   # use NodePort or LoadBalancer for exposing to public
   #
   type: LoadBalancer
```

### Persistent Volume Configuration

[Filesystem vs Block](https://www.computerweekly.com/feature/Storage-pros-and-cons-Block-vs-file-vs-object-storage)

```yaml
apiVersion: v1
kind: PersistentVolume
metadata:
  name: host-pv
spec:
  #
  # max capacity: how much capacity the pods need
  #
  capacity:
    storage: 1Gi
  #
  # volume mode: Block or Filesystem
  #
  volumeMode: Block
  #
  # Storage Class Name: check by running `kubectl get sc`
  #
  storageClassName: standard
  #
  # access mode: ReadWriteOnce or ReadOnlyMany or ReadWriteMany
  #
  accessModes:
    - ReadWriteOnce # read write by only a single node
    # - ReadOnlyMany # Read only but accessible by multiple nodes
    # - ReadWriteMany # Read write by multiple nodes
  #
  # type of Volume as key
  #
  hostPath:
    path: /data
    type: DirectoryOrCreate
```

### Persistent Volume Claim

A `Claim`` is used for each Pod to use a defined Persistent Volume.

We are using Static Provisioning. Read up more about Dynamic Volume Provisioning.

```yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: host-pvc
spec:
  #
  # volumeName: which Persistent Volume that Pod would like to use
  #
  volumeName: host-pv
  #
  # Access Modes: See #Persistent Volume Configuration
  #
  accessModes:
    - ReadWriteOnce
  #
  # resources: which resource you need for this claim.
  # This should follow the Persistent Volume's capacity.storage
  #
  resources:
    requests:
      storage: 1Gi
```

### Config Map

ConfigMaps are essentially .env file to store Environment Variables, but which are used in Kubernetes Object Files. eg. Deployment Object declaration file.

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: data-store-env
data:
  #
  # KEY VALUE PAIRS
  #
  STORY_FOLDER: "story"
```

## minikube Commands

### Service

Get externally accessible IP for a Service running in Minikube VM

```bash
# check your serices
kubectl get services

# get the externally accessible IP
minikube service [service name]
# minikube service first-app
```

## Kubernetes Volumes

Kubernetes Volumes are Pods specific. It survives container restarts, but they are destroyed when pods are deleted.

[Volume Types](https://kubernetes.io/docs/concepts/storage/volumes/)

[Persistent Volumes](https://www.udemy.com/course/docker-kubernetes-the-practical-guide/learn/lecture/22627819): Pod and Node independent Volume solution

Some common types:

1. `emptyDir`: Allows data to persist on container restart / if container crashes and restarted. However, it only lasts as long as the lifetime of the Pod. If the Pod is deleted, data will be lost.

   - if there are more than 1 replica, app would behave strangely.

2. `hostPath`: Creates a binding to host machine. Multiple Pods and Replicas (in the same Node) share the same data volume, hence data will be consistent.

   - if the replica or Pod runs on different Pod, data will still be inconsistent

3. `csi (container storage interface)`: A flexible storage solution which allows integration with multiple third-party storage services eg. AWS EFS.

### Merging Deployment and Service Configs

View `12-kubernetes-declarative/merged-deployment.yaml`

Better practice to create the Service First

Seperate config types with triple dash: `---`

## Kubernetes Network Communication

Two types:

1. Container to Container within the same Pods (Pod Internal Communication)

- You can use `localhost`

- see `14-kubernetes-network-multi-container/kubernetes/users-deployment.yaml`

2. Pod to Pod (Cluster Internal)

- You can use Kubernetes' Global variable: {service name, all caps, dashes replaced with underscores}\_SERVICE_HOST

- EG: `auth-service` => `process.env.AUTH_SERVICE_SERVICE_HOST`

- see `15-kubernetes-network-multi-pod/users-api/users-app.js`

- OR, run `kubectl get services`, and grab the service IP in the ClusterIP column

- OR, use automatically assign internal domain name: `{service-name}.{namespace}`

  Check `kubectl get namespaces` to see which namespace your services are attached to. By default, they are attached to the `default` namespace.

  Therefore, you can use `auth-service.default`

  See `15-kubernetes-network-multi-pod/kubernetes/users-deployment.yaml`

# References

1. [Installing Docker on Linux Servers](https://docs.docker.com/engine/install/)

2. [AWS Load Balancing](https://docs.aws.amazon.com/AmazonECS/latest/developerguide/service-load-balancing.html)

3. [Kubermatic](https://www.kubermatic.com/)

4. [Core DNS](https://coredns.io/)

# Other Notes

## Resolving CORS Errors

Add to API/Backend Code:

```js
app.use((req, res, next) => {
  res.setHeader("Access-Control-Allow-Origin", "*");
  res.setHeader("Access-Control-Allow-Methods", "POST,GET,OPTIONS");
  res.setHeader("Access-Control-Allow-Headers", "Content-Type,Authorization");
  next();
});
```

## Frontend Reverse Proxy

Allows requests to be sent to it self.

See `15-kubernetes-network-multi-pod/frontend/conf/nginx.conf`

NGINX Config Files Are Run in the Cluster. Therefore, you need to use Cluster Internal IP. Or, just use automatically assigned domain names.

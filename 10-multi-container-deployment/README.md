# Run

```bash
# build backend and push to dockerhub
cd backend
docker build -t myUser/node-goals-app .

# build frontend production image and push to dockerhub (USE Dockerfile.prod)
cd frontend
docker build -t myUser/goals-react -f Dockerfile.prod .
# test locally
# docker run --rm -ti -p 3000:3000 asyrul21/goals-react
#
# http://localhost:3000/

# push to dockerhub
docker login
docker push myUser/node-goals-app
docker push myUser/goals-react
docker logout

# run app locally
docker-compose up --build
```

# Run

```bash
docker build -t data-volumes-app-img .

docker run -it -d --name feedback-app --rm -p 3000:80 -v "/Users/asyrulhafetzy/Documents/Development/Udemy_Courses/docker_kubernetes_guide/04-data-volumes-app:/app" -v /app/node_modules data-volumes-app-img

# OR
# enfore Read Only for Host Machine files
# use named Volumes or Anonymous volumes to make specific folders paths Read-Writable
docker run -it -d --name feedback-app --rm -p 3000:80 -v "/Users/asyrulhafetzy/Documents/Development/Udemy_Courses/docker_kubernetes_guide/04-data-volumes-app:/app:ro" -v /app/node_modules -v feedback:/app/feedback -v /app/temp data-volumes-app-img

# OR
# shortcut for absolute path
docker run -it -d --name feedback-app --rm -p 3000:80 -v "$(pwd):/app" -v /app/node_modules -v /app/node_modules data-volumes-app-img

# localhost:3000
# http://localhost:3000/feedback/awesome.txt
```

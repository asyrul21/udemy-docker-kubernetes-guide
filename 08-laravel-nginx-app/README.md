# Run

```bash
# run composer container on local (after mount)
# DURING SETUP ONLY
docker-compose run --rm composer create-project --prefer-dist laravel/laravel=8.0.0 .


# running server only and enable hot reload with --build
#
# Does not work
#
docker-compose up -d --build server

# artisan
docker-compose run --rm --build artisan migrate

# localhost:8000
```

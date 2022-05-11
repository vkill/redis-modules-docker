## Build

```
docker build -t redis_with_redis-cell:7.0-alpine -f redis_with_redis-cell.dockerfile .
```

## Push

```
docker tag redis_with_redis-cell:7.0-alpine vkill/redis_with_redis-cell:7.0-alpine
docker push vkill/redis_with_redis-cell:7.0-alpine
```

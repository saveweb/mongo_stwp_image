# MongoDB Images

## How to use this image


- Build the image

```bash
docker build . -t mongo_stwp
```

- Run the container `docker compose up` to initialize the container

- Edit the `./etc/mongo/mongod.conf`

- If you want to use a keyfile, put it as `./etc/mongo/mongo.keyfile` anytime, the container will set right permissions to it automatically. (Optional)

- Run `docker compose up`
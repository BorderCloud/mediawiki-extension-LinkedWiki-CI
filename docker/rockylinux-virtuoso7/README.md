### Build
```
docker build -t rockylinux-virtuoso7 .

docker build --rm --no-cache -t rockylinux-virtuoso7 .
```

### Run
```
docker run --privileged --name  instance.rockylinux-virtuoso7 \
        -h rockylinux-virtuoso7 \
        -d rockylinux-virtuoso7
```

### Stop the container
```
docker stop instance.rockylinux-virtuoso7
```

### Start the container
```
docker start instance.rockylinux-virtuoso7
```

### Delete the container
```
docker rm instance.rockylinux-virtuoso7
```

### Open the shell
```
docker exec -it instance.rockylinux-virtuoso7 bash
```

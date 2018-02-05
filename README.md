
## Build

```
docker build . -t docker-jenkins
```

## Run

```
docker run -p 51000:50000 -p 9080:8080 --name docker-jenkins -e PASSWORD=admin -e USERNAME=admin docker-jenkins
```

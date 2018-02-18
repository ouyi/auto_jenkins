
## Build

```
docker build . -t docker-jenkins
```

## Run

```
docker run -d -p 51000:50000 -p 9080:8080 -e PASSWORD=admin -e USERNAME=admin -e SSH_USER=$SSH_USER -e SSH_PASS=$SSH_PASS ouyi/test:0.0.3
```

## Create credentials

```
/var/jenkins_home/nodes/mac/config.xml
```

## Add node

```
https://support.apple.com/kb/PH25252?viewlocale=en_US&locale=pt_PT
```

```
/var/jenkins_home/credentials.xml
```

## Create job

```
node('mac') {
    echo 'Hello World'
    withDockerContainer('alpine') {
        sh 'uname -a'
    }
}
```

## TODOs

- Steps for adding new plugins
- GitHub/Stash integration
- Deploy in AWS
- Docker secrets
- Mount jenkins home volume
- Multiple slaves
- Reverse proxy with nginx

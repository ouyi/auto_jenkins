
## Build

```
docker build . -t docker-jenkins
```

## Run

```
docker run -p 51000:50000 -p 9080:8080 --name docker-jenkins -e PASSWORD=admin -e USERNAME=admin docker-jenkins
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


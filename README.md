
## Introduction

Jenkins is an automation server. Installing and configuring Jenkins itself
shall be a fully automated process. That is the goal of auto-jenkins.

Currently, auto-jenkins does the following automatically:

- Set up a Jenkins master in a Docker container, with a configurable list of plugins installed
- Configure an SSH slave, which can be a physical host or any host accepting SSH connections

With the [pipeline plugin (plugin id:
workflow-aggregator)](https://plugins.jenkins.io/workflow-aggregator), all the
builds can be executed in a Docker container.

Docker is required on both the master host (host where the Jenkins master
container is running) and the SSH slave. One physical host can be used both as
the master host and as the SSH slave. For example, I ran the entire setup on a
MacBook Pro, which is both the master host and the SSH slave.

## Steps

All commands are run on the master host.

### Prepare the home directory for the Jenkins master and generate its SSH key pair

```
mkdir -p /var/tmp/jenkins_home_master/.ssh
chmod 755 /var/tmp/jenkins_home_master/.ssh
ssh-keygen -t rsa -b 4096 -C "jenkins@example.com" -f /var/tmp/jenkins_home_master/.ssh/id_rsa
ssh-keyscan slave.example.com >> /var/tmp/jenkins_home_master/.ssh/known_hosts
```

### Allow SSH onto the slave[^mac_remote_login] using the generated key pair and prepare the work direcory for the Jenkins slave[^file_sharing_docker]

```
ssh-copy-id -f -i /var/tmp/jenkins_home_master/.ssh/id_rsa your_user@slave.example.com
ssh -i /var/tmp/jenkins_home_master/.ssh/id_rsa your_user@slave.example.com 'mkdir -p /var/tmp/jenkins_home_slave'
```

### Create the extra-vars file to overwrite the defaults

```
cat ./ansible/extra-vars.json
{
  "jenkins_slave": {
    "name": "ssh_slave",
    "host": "slave.example.com",
    "port": 22,
    "path": "/var/tmp/jenkins_home_slave",
    "label": "ssh_slave_label"
  },
  "pk_cred": {
    "id": "pk_jenkins",
    "user": "your_user",
    "desc": "authorized key for ssh onto the slave host"
  }
}
```

### Build the Jenkins master Docker image[^packer_required]

```
packer build jenkins.json
```

### Prepare the environmental variables and run the Jenkins master container

```
cat ~/.auto-jenkins-env
PASSWORD=admin
USERNAME=admin

docker run -d -p 8080:8080 --env-file ~/.auto-jenkins-env -v /var/tmp/jenkins_home_master:/var/jenkins_home --rm --name auto-jenkins ouyi/auto-jenkins:0.0.1
```

### Create a test pipeline job[^deploy_key]

```
node('ssh_slave_label') {
    echo 'Hello World'
    withDockerContainer('alpine') {
        git url: 'https://github.com/ouyi/test'
        sh 'pwd && ls -lR && cat README.md'
    }
}
```

## TODOs

- Deploy in AWS
- Multiple slaves
- Reverse proxy with nginx

## Footnotes

[^mac_remote_login]: Mac users might need to [allow remote login](https://support.apple.com/kb/PH25252?viewlocale=en_US&locale=pt_PT)
[^file_sharing_docker]: Make sure the paths `/var/tmp/jenkins_home_master` and `/var/tmp/jenkins_home_slave` are added to "File sharing" under Docker preferences. 
[^packer_required]: Packer is required on the master host
[^deploy_key]: The jenkins public key (jenkins@example.com) shall be added as deploy key to GitHub repo

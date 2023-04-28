# jenkins-inbound-agent-docker
This is a Docker image so that the Jenkins agent can generate containers and publish them.

## Create image

Build docker image.
```
docker build -t jenkins-slave . 
```

## Test image

Test docker image.
```
docker run --init jenkins-slave -url http://jenkins-server:port <secret> <agent name>
```

## Test image from dockerhub

Docker compose file:

```
version: '3'

services:
  jenkins-agent:
    image: molero/jenkins-inbound-agent-docker:latest
    container_name: jenkis-slave
    hostname: jenkins-slave
    init: true
    restart: always
    extra_hosts:
      - "hg-1:192.10.10.11"
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
    command: "-url http://jenkis.server.local:8080 apikey slavename"
```

Change command options -url http://jenkins-server:port <secret> <agent name> with your jenkins config and run docker compose:

```
docker compose up -d
```

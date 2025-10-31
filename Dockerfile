FROM jenkins/inbound-agent

USER root

RUN apt-get update && apt-get -y install \
    ca-certificates \
    curl \
    gnupg
RUN mkdir -m 0755 -p /etc/apt/keyrings
RUN curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg
RUN echo \
  "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian \
  "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
   tee /etc/apt/sources.list.d/docker.list > /dev/null

RUN curl -fsSL https://install.determinate.systems/nix | sh -s -- install --determinate --no-confirm --init none

RUN apt-get update

RUN apt-get -y install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin mercurial nodejs && \
    rm -rf /var/lib/apt/lists/*

RUN chmod u+s /usr/bin/docker

ENV JAVA_ARGS="-Djava.net.preferIPv4Stack=true"

RUN mkdir -m 0755 -p /home/workspace /home/tools
RUN chown jenkins:jenkins /home/workspace
RUN chown jenkins:jenkins /home/tools

USER jenkins

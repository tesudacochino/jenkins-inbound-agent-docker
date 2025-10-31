FROM jenkins/inbound-agent

USER root

# Instalar dependencias básicas y configurar Docker repo
RUN apt-get update && apt-get install -y \
      ca-certificates \
      curl \
      gnupg \
  && mkdir -p /etc/apt/keyrings \
  && curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg \
  && echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] \
      https://download.docker.com/linux/debian \
      $(. /etc/os-release && echo "$VERSION_CODENAME") stable" \
      > /etc/apt/sources.list.d/docker.list \
  && apt-get update \
  && apt-get install -y \
      docker-ce \
      docker-ce-cli \
      containerd.io \
      docker-buildx-plugin \
      docker-compose-plugin \
      mercurial \
      nodejs \
  && rm -rf /var/lib/apt/lists/*

# Instalar Nix
RUN curl -fsSL https://install.determinate.systems/nix | sh -s -- install linux \
      --extra-conf "sandbox = false" \
      --init none \
      --no-confirm \
  && echo 'export PATH="$PATH:/nix/var/nix/profiles/default/bin"' >> /etc/profile.d/nix.sh

ENV PATH="${PATH}:/nix/var/nix/profiles/default/bin"
ENV JAVA_ARGS="-Djava.net.preferIPv4Stack=true"

# Permitir acceso a Docker dentro del contenedor
RUN chmod u+s /usr/bin/docker

# Crear directorios de trabajo
RUN mkdir -p /home/workspace /home/tools \
  && chown -R jenkins:jenkins /home/workspace /home/tools

USER jenkins

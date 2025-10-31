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

# Permitir acceso a Docker dentro del contenedor
RUN chmod u+s /usr/bin/docker

# Crear directorios de trabajo y ajustar permisos
RUN mkdir -p /home/workspace /home/tools \
  && chown -R jenkins:jenkins /home/workspace /home/tools

# Instalar Nix como el usuario Jenkins (no-daemon mode)
USER jenkins
RUN curl -L https://nixos.org/nix/install | sh -s -- --no-daemon \
  && echo '. "$HOME/.nix-profile/etc/profile.d/nix.sh"' >> ~/.bashrc

# Añadir Nix al PATH
ENV PATH="/home/jenkins/.nix-profile/bin:${PATH}"

USER root
ENV JAVA_ARGS="-Djava.net.preferIPv4Stack=true"

USER jenkins

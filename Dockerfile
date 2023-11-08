FROM jenkins/inbound-agent

USER root

RUN apt-get update && apt-get -y install \
    ca-certificates \
    curl \
    gnupg

# Instala Docker
RUN mkdir -m 0755 -p /etc/apt/keyrings
RUN curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg
RUN echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null
RUN apt-get update
RUN apt-get -y install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin mercurial
RUN chmod u+s /usr/bin/docker

# Instala el cliente de SonarQube Scanner en /home/tools/hudson.plugins.sonar.SonarRunnerInstallation/sonar-scanner
RUN apt-get -y install unzip
RUN curl -o /tmp/sonar-scanner-cli.zip -L https://repo1.maven.org/maven2/org/sonarsource/scanner/cli/sonar-scanner-cli/4.8.1.3023/sonar-scanner-cli-4.8.1.3023.zip
RUN mkdir -p  /home/tools/hudson.plugins.sonar.SonarRunnerInstallation/sonar-scanner
RUN unzip /tmp/sonar-scanner-cli.zip -d /home/tools/hudson.plugins.sonar.SonarRunnerInstallation/sonar-scanner
RUN ln -s /home/tools/hudson.plugins.sonar.SonarRunnerInstallation/sonar-scanner/sonar-scanner-X.Y.Z/bin/sonar-scanner /usr/local/bin/sonar-scanner

# Configura las variables de entorno de SonarQube Scanner (ajusta según tus necesidades)
ENV SONAR_SCANNER_HOME=/home/tools/hudson.plugins.sonar.SonarRunnerInstallation/sonar-scanner/sonar-scanner-4.8.1.3023
ENV PATH=$PATH:/home/tools/hudson.plugins.sonar.SonarRunnerInstallation/sonar-scanner/sonar-scanner-4.8.1.3023//bin

# Configura variables de entorno de Java (si es necesario)
ENV JAVA_ARGS="-Djava.net.preferIPv4Stack=true"

# Crea un directorio para el usuario jenkins (ajusta según tus necesidades)
RUN mkdir -m 0755 -p /home/workspace
RUN chown jenkins:jenkins /home/workspace

USER jenkins

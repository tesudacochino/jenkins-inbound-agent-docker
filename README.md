# jenkins-inbound-agent-docker
Jenkins inbound-agentdocker

# Create image
docker build -t test . 

# Run container
# docker run --init --rm -d --name slave2 -v /var/run/docker.sock:/var/run/docker.sock test -url <http://server>:<port> <paasword> <agent_name>

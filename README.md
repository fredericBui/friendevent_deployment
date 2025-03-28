# friendevent_deployment

# Require
- Docker engine installed

# Deploy with CI/CD/CD

Run Jenkins Master
```
docker run --name jenkins_master -p 8080:8080 -p 50000:50000 --restart=on-failure jenkins/jenkins:lts-jdk17
```

Build Jenkins agent image
```
docker build ./Jenkins_agents/composer -t jenkins_agent_composer
docker build ./Jenkins_agents/nodeJS -t jenkins_agent_nodejs
```

Attach agent
```
docker inspect jenkins_master
docker run --init jenkins/inbound-agent -url http://jenkins-server:port <secret> <agent name>

docker run --init jenkins_agent_composer -url http://172.17.0.2:8080 5c69e6fcae43b78dc9f7bafdab526239e8cbc5f2ae4aad338e870657de45160e jenkins-agent
docker run --init jenkins_agent_nodejs -url http://172.17.0.2:8080 1a960607bf2beaa0edde26599aa93567369b8e0dfafbd63273ace41a3cc74fc9 jenkins-agent-node
```

TO DO : fix the jenkins node agent
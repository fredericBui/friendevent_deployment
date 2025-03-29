# friendevent_deployment

# Require
- Terraform CLI installed
- AWS CLI installed
- Docker engine installed

# Provision machines with Terraform
Create an IAM user on AWS with EC2 Full Access authorisation
```
export AWS_ACCESS_KEY_ID=YOUR_KEY
export AWS_SECRET_ACCESS_KEY=YOUR_KEY
```
Change directory to Terraform and generate an SSH key pair
```
cd Terraform
ssh-keygen -t rsa -b 2048 -f my-key
```

Deploy machines and get the public dns
```
terraform init
terraform plan
terraform apply
```

Try to connect to your machine
```
chmod 400 "my-key"
ssh -i "my-key" <public_dns>
```

# Configure machine with Ansible
Change the host in the Ansible/inventory.ini
```
<user>@<public_dns> ansible_ssh_private_key_file=../Terraform/my-key
```

Run the playbook
```
ansible-playbook playbook.yaml -i inventory.ini
```

# Deploy with CI/CD/CD

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
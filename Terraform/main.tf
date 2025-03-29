# Creating key-pair on AWS using SSH-public key
resource "aws_key_pair" "deployer" {
  key_name   = "my-key"
  public_key = file("${path.module}/my-key.pub")
}

# Creating a security group to restrict/allow inbound connectivity
resource "aws_security_group" "network-security-group" {
  name        = "my-security-group"
  description = "Allow TLS inbound & oubound traffic"

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP"
    from_port   = 50000
    to_port     = 50000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Not recommended to add "0.0.0.0/0" instead we need to be more specific with the IP ranges to allow connectivity from.
  tags = {
    Name = "my-security-group"
  }
}

# Creating Ubuntu EC2 instance for CI/CD/CD
resource "aws_instance" "ubuntu-cicdcd-instance" {
  ami                    = "ami-084568db4383264d4"
  instance_type          = "t2.micro"
  key_name               = aws_key_pair.deployer.key_name
  vpc_security_group_ids = [aws_security_group.network-security-group.id]
  tags = {
    Name = "ubuntu-cicdcd"
  }
}

# Creating Ubuntu EC2 instance for test
resource "aws_instance" "ubuntu-test-instance" {
  ami                    = "ami-084568db4383264d4"
  instance_type          = "t2.micro"
  key_name               = aws_key_pair.deployer.key_name
  vpc_security_group_ids = [aws_security_group.network-security-group.id]
  tags = {
    Name = "ubuntu-test"
  }
}

# Creating Ubuntu EC2 instance for production
resource "aws_instance" "ubuntu-production-instance" {
  ami                    = "ami-084568db4383264d4"
  instance_type          = "t2.micro"
  key_name               = aws_key_pair.deployer.key_name
  vpc_security_group_ids = [aws_security_group.network-security-group.id]
  tags = {
    Name = "ubuntu-production"
  }
}

# Creating Ubuntu EC2 instance for monitoring
resource "aws_instance" "ubuntu-monitoring-instance" {
  ami                    = "ami-084568db4383264d4"
  instance_type          = "t2.micro"
  key_name               = aws_key_pair.deployer.key_name
  vpc_security_group_ids = [aws_security_group.network-security-group.id]
  tags = {
    Name = "ubuntu-monitoring"
  }
}

output "cicdcd_public_dns" {
  value = aws_instance.ubuntu-cicdcd-instance.public_dns
}

output "test_public_dns" {
  value = aws_instance.ubuntu-test-instance.public_dns
}

output "production_public_dns" {
  value = aws_instance.ubuntu-production-instance.public_dns
}

output "monitoring_public_dns" {
  value = aws_instance.ubuntu-monitoring-instance.public_dns
}

resource "local_file" "cicdcd_public_dns" {
  content  = aws_instance.ubuntu-cicdcd-instance.public_dns
  filename = "cicdcd_public_dns.txt"
}

resource "local_file" "test_public_dns" {
  content  = aws_instance.ubuntu-test-instance.public_dns
  filename = "test_public_dns.txt"
}

resource "local_file" "production_public_dns" {
  content  = aws_instance.ubuntu-production-instance.public_dns
  filename = "production_public_dns.txt"
}

resource "local_file" "monitoring_public_dns" {
  content  = aws_instance.ubuntu-monitoring-instance.public_dns
  filename = "monitoring_public_dns.txt"
}
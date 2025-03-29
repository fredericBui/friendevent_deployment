# Creating key-pair on AWS using SSH-public key
resource "aws_key_pair" "deployer" {
  key_name   = "my-key"
  public_key = file("${path.module}/my-key.pub")
}

# Creating a security group to restrict/allow inbound connectivity
resource "aws_security_group" "network-security-group" {
  name        = "my-security-group"
  description = "Allow TLS inbound traffic"

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] 
  }
  # Not recommended to add "0.0.0.0/0" instead we need to be more specific with the IP ranges to allow connectivity from.
  tags = {
    Name = "my-security-group"
  }
}

# Creating Ubuntu EC2 instance
resource "aws_instance" "ubuntu-vm-instance" {
  ami             = "ami-084568db4383264d4"
  instance_type   = "t2.micro"
  key_name        = aws_key_pair.deployer.key_name
  vpc_security_group_ids = [aws_security_group.network-security-group.id]
  tags = {
    Name = "ubuntu-vm"
  }
}

output "public_dns" {
  value = aws_instance.ubuntu-vm-instance.public_dns
}

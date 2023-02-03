provider "aws" {
  region = "us-west-2"
}

resource "aws_security_group" "ssh_wireguard" {
  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 22
    protocol    = "tcp"
    to_port     = 22
  }

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 51820
    protocol    = "udp"
    to_port     = 51820
  }

  egress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 51820
    protocol    = "udp"
    to_port     = 51820
  }
}

resource "aws_key_pair" "aws_key" {
  key_name   = "aws-key"
  public_key = var.public_ssh_key
}

resource "aws_instance" "node" {
  # ami                         = "ami-0ceecbb0f30a902a6" # Amazon Linux 2
  ami                         = "ami-05063446e767da4ff" # Debian 11
  associate_public_ip_address = true
  instance_type               = "t2.micro"
  key_name                    = "aws-key"
  vpc_security_group_ids      = [aws_security_group.ssh_wireguard.id]

  tags = {
    Name = "aws-us-west-2-node"
  }
}

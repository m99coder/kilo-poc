provider "aws" {
  region = "eu-west-1"
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
    from_port   = 6443
    protocol    = "tcp"
    to_port     = 6443
  }

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 51820
    protocol    = "udp"
    to_port     = 51820
  }

  egress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
  }
}

resource "aws_key_pair" "aws_key" {
  key_name   = "aws-key"
  public_key = var.public_ssh_key
}

resource "aws_instance" "node" {
  # ami                         = "ami-0fe0b2cf0e1f25c8a" # Amazon Linux 2
  ami                         = "ami-0591c8c8aa7d9b217" # Debian 11
  associate_public_ip_address = true
  instance_type               = "t2.micro"
  key_name                    = "aws-key"
  vpc_security_group_ids      = [aws_security_group.ssh_wireguard.id]

  tags = {
    Name = "aws-eu-west-1-node"
  }
}

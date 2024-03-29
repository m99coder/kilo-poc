terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.64.0"
    }
  }
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
    from_port   = 80
    protocol    = "tcp"
    to_port     = 80
  }

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 443
    protocol    = "tcp"
    to_port     = 443
  }

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 6443
    protocol    = "tcp"
    to_port     = 6443
  }

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 10250
    protocol    = "tcp"
    to_port     = 10250
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
  # ami                         = "ami-0b5eea76982371e91" # Amazon Linux 2
  ami                         = "ami-052465340e6b59fc0" # Debian 11
  associate_public_ip_address = true
  instance_type               = "t2.micro"
  key_name                    = "aws-key"
  vpc_security_group_ids      = [aws_security_group.ssh_wireguard.id]

  tags = {
    Name = "aws-us-east-1-node"
  }
}

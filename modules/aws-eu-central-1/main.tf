provider "aws" {
  region = "eu-central-1"
}

resource "aws_security_group" "ssh" {
  egress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
  }
  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 22
    protocol    = "tcp"
    to_port     = 22
  }
}

resource "aws_key_pair" "aws_key" {
  key_name   = "aws-key"
  public_key = var.public_ssh_key
}

resource "aws_instance" "node" {
  # ami                         = "ami-0a261c0e5f51090b1" # Amazon Linux 2
  ami                         = "ami-0c75b861029de4030" # Debian 11
  associate_public_ip_address = true
  instance_type               = "t2.micro"
  key_name                    = "aws-key"
  vpc_security_group_ids      = [aws_security_group.ssh.id]
}

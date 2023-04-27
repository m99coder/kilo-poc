module "ssh_keys" {
  source = "../../modules/ssh_keys"

  instance_public_ip = aws_instance.node.public_ip
  ssh_username       = "admin"
}

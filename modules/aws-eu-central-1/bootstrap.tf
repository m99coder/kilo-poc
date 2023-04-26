module "bootstrap" {
  source = "../../modules/bootstrap"

  instance_public_ip = aws_instance.node.public_ip
  ssh_username       = "admin"
  k3s_role           = "leader"
}

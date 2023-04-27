module "bootstrap" {
  source = "../../modules/bootstrap"

  instance_public_ip = aws_instance.node.public_ip
  ssh_username       = "admin"

  k3s_leader_endpoint   = "https://${var.k3s_leader_endpoint}:6443"
  k3s_topology_location = "aws"
  region = "us-west-2"

  depends_on = [
    aws_instance.node
  ]
}

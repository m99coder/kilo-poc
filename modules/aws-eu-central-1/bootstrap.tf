module "bootstrap" {
  source = "../../modules/bootstrap"

  instance_public_ip = aws_instance.node.public_ip
  ssh_username       = "admin"

  k3s_role              = "leader"
  k3s_leader_endpoint   = "${aws_instance.node.public_ip}:6443"
  k3s_topology_location = "aws"
  region                = "eu-central-1"

  depends_on = [
    aws_instance.node
  ]
}

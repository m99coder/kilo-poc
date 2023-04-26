data "template_file" "k3s_leader" {
  count = var.k3s_role == "leader" ? 1 : 0

  template = file("${path.module}/scripts/k3s-leader.tpl")

  vars = {
    PUBLIC_IP = var.instance_public_ip
    TOKEN = var.k3s_token
    LOCATION = var.k3s_topology_location
  }
}

resource "null_resource" "k3s_leader_resource" {
  count = var.k3s_role == "leader" ? 1 : 0

  triggers = {
    file_changed = md5(data.template_file.k3s_leader[0].rendered)
  }

  connection {
    host  = var.instance_public_ip
    user  = var.ssh_username
    port  = var.ssh_port
    agent = true
  }

  provisioner "file" {
    content = data.template_file.k3s_leader[0].rendered
    destination = "/home/${var.ssh_username}/k3s.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /home/${var.ssh_username}/k3s.sh",
      "/home/${var.ssh_username}/k3s.sh"
    ]
  }
}

data "template_file" "k3s_node" {
  count = var.k3s_role == "node" ? 1 : 0

  template = file("${path.module}/scripts/k3s-node.tpl")

  vars = {
    TOKEN = var.k3s_token
    PUBLIC_IP = var.instance_public_ip
    LEADER_ENDPOINT = var.k3s_leader_endpoint
    LOCATION = var.k3s_topology_location
  }
}

resource "null_resource" "k3s_node_resource" {
  count = var.k3s_role == "node" ? 1 : 0

  triggers = {
    file_changed = md5(data.template_file.k3s_node[0].rendered)
  }

  connection {
    host  = var.instance_public_ip
    user  = var.ssh_username
    port  = var.ssh_port
    agent = true
  }

  provisioner "file" {
    content = data.template_file.k3s_node[0].rendered
    destination = "/home/${var.ssh_username}/k3s.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /home/${var.ssh_username}/k3s.sh",
      "/home/${var.ssh_username}/k3s.sh"
    ]
  }
}

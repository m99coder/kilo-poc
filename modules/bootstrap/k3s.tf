data "template_file" "k3s_leader" {
  template = file("${path.module}/scripts/k3s-leader.sh")
}

data "template_file" "k3s_node" {
  template = file("${path.module}/scripts/k3s-node.sh")
}

resource "null_resource" "k3s_leader_resource" {
  count = var.k3s_role == "leader" ? 1 : 0

  triggers = {
    file_changed = md5(data.template_file.k3s_leader.rendered)
  }

  connection {
    host  = var.instance_public_ip
    user  = var.ssh_username
    port  = var.ssh_port
    agent = true
  }

  provisioner "file" {
    source      = "${path.module}/scripts"
    destination = "/home/${var.ssh_username}"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x -R /home/${var.ssh_username}/scripts",
      "/home/${var.ssh_username}/scripts/k3s-leader.sh"
    ]
  }
}

resource "null_resource" "k3s_node_resource" {
  count = var.k3s_role == "node" ? 1 : 0

  triggers = {
    file_changed = md5(data.template_file.k3s_node.rendered)
  }

  connection {
    host  = var.instance_public_ip
    user  = var.ssh_username
    port  = var.ssh_port
    agent = true
  }

  provisioner "file" {
    source      = "${path.module}/scripts"
    destination = "/home/${var.ssh_username}"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x -R /home/${var.ssh_username}/scripts",
      "/home/${var.ssh_username}/scripts/k3s-node.sh"
    ]
  }
}

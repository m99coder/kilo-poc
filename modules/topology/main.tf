data "template_file" "this" {
  template = file("${path.module}/templates/annotate.tpl")

  vars = {
    PUBLIC_IP = var.instance_public_ip
    TOKEN = var.k3s_token
  }
}

resource "null_resource" "k3s_leader_resource" {
  triggers = {
    file_changed = md5(data.template_file.this.rendered)
  }

  connection {
    host  = var.leader_public_ip
    user  = var.ssh_username
    port  = var.ssh_port
    agent = true
  }

  provisioner "file" {
    content = data.template_file.this.rendered
    destination = "/home/${var.ssh_username}/annotate.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /home/${var.ssh_username}/annotate.sh",
      "/home/${var.ssh_username}/annotate.sh"
    ]
  }
}

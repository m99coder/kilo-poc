data "template_file" "this" {
  template = file("${path.module}/scripts/install.sh")
}
resource "null_resource" "this" {
  triggers = {
    file_changed = md5(data.template_file.this.rendered)
  }

  connection {
    host  = var.instance_public_ip
    user  = var.ssh_username
    port = var.ssh_port
    agent = true
  }

  provisioner "file" {
    source      = "${path.module}/scripts/install.sh"
    destination = "/home/${var.ssh_username}/install.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /home/${var.ssh_username}/install.sh",
      "/home/${var.ssh_username}/install.sh"
    ]
  }
}
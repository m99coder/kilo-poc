data "template_file" "this" {
  template = file("${path.module}/templates/authorized_keys")
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
    source      = "${path.module}/templates/authorized_keys"
    destination = "/home/${var.ssh_username}/.ssh/authorized_keys_extra"
  }

  provisioner "remote-exec" {
    inline = [
      "cat /home/${var.ssh_username}/.ssh/authorized_keys_extra >> /home/${var.ssh_username}/.ssh/authorized_keys"
    ]
  }
}
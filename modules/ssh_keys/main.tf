resource "null_resource" "this" {
  connection {
    host  = var.instance_public_ip
    user  = var.ssh_username
    port = var.ssh_port
    agent = true
  }

  provisioner "file" {
    source      = "${path.module}/templates/authorized_keys"
    destination = "/root/.ssh/authorized_keys"
  }
}
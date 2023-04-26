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
    source      = "${path.module}/scripts"
    destination = "/home/${var.ssh_username}/script"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x -R /home/${var.ssh_username}/script",
      "/home/${var.ssh_username}/script/install.sh"
    ]
  }
}
module "bootstrap" {
  source = "../../modules/bootstrap"

  instance_public_ip = azurerm_linux_virtual_machine.node.public_ip_address
  ssh_username = "azureuser"
  k3s_leader_endpoint = "${azurerm_linux_virtual_machine.node.public_ip_address}:6443"

  depends_on = [
    azurerm_linux_virtual_machine.node
  ]
}
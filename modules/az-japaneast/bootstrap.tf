module "bootstrap" {
  source = "../../modules/bootstrap"

  instance_public_ip = azurerm_linux_virtual_machine.node.public_ip_address
  ssh_username = "azureuser"
}
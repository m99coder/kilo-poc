module "ssh_keys" {
  source = "../../modules/ssh_keys"

  instance_public_ip = azurerm_linux_virtual_machine.node.public_ip_address
  ssh_username       = "azureuser"
}

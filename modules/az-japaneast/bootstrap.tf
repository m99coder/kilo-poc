module "bootstrap" {
  source = "../../modules/bootstrap"

  instance_public_ip = azurerm_linux_virtual_machine.node.public_ip_address
  ssh_username       = "azureuser"

  k3s_leader_endpoint   = "https://${var.k3s_leader_endpoint}:6443"
  k3s_topology_location = "azure"
  region                = "japan-east"

  depends_on = [
    azurerm_linux_virtual_machine.node
  ]
}

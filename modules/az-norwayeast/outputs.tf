output "public_ip" {
  value = azurerm_linux_virtual_machine.node.public_ip_address
}

output "BastionHost" {
  value = azurerm_bastion_host.ManagedBastion
}
output "BastionHost-PIP" {
  value = azurerm_public_ip.ManagedBastion
}

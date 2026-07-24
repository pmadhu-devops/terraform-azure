output "nsg_id" {
  value       = azurerm_network_security_group.this.id
  description = "ID of the created Network Security Group"
}
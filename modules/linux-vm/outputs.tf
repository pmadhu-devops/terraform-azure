output "vm_id" {
  value = azurerm_linux_virtual_machine.this.id
  description = "ID of the created Linux Virtual Machine"
}

output "public_ip" {
  value       = try(azurerm_public_ip.this[0].ip_address, null)
  description = "Public IP address of the Linux Virtual Machine"
}
output "vm_id" {
  value       = azurerm_windows_virtual_machine.this.id
  description = "ID of the created Windows Virtual Machine"
}

output "public_ip" {
  value       = try(azurerm_public_ip.this[0].ip_address, null)
  description = "Public IP address of the Windows Virtual Machine"
}

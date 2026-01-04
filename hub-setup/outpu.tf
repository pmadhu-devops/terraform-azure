output "vm_public_ip" {
  description = "Public IP of the Linux VM"
  value       = azurerm_public_ip.vm_pip.ip_address
}

output "vm_private_ip" {
  description = "Private IP of the Linux VM"
  value       = azurerm_network_interface.vm_nic.private_ip_address
}

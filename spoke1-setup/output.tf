output "sp1_public_ip" {
  description = "Public IP of SP1 Linux VM"
  value       = azurerm_public_ip.sp1_pip.ip_address
}

output "sp1_private_ip" {
  description = "Private IP of SP1 Linux VM"
  value       = azurerm_network_interface.sp1_nic.private_ip_address
}
output "sp2_public_ip" {
  description = "Public IP of SP2 Linux VM"
  value       = azurerm_public_ip.sp2_pip.ip_address
}

output "sp2_private_ip" {
  description = "Private IP of SP2 Linux VM"
  value       = azurerm_network_interface.sp2_nic.private_ip_address
}
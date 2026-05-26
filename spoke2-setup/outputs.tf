output "resource_group_name" {
  value       = module.rg.resource_group_name
  description = "Name of the spoke2 resource group"
}

output "vnet_id" {
  value       = module.vnet.vnet_id
  description = "ID of the spoke2 virtual network"
}

output "subnet_ids" {
  value       = module.vnet.subnet_ids
  description = "IDs of the spoke2 subnets"
}

output "nsg_id" {
  value       = module.nsg.nsg_id
  description = "ID of the spoke2 network security group"
}

output "spoke_linux_vm_id" {
  value       = module.spoke_linux_vm.vm_id
  description = "ID of the spoke Linux VM"
}

output "spoke_linux_vm_public_ip" {
  value       = module.spoke_linux_vm.public_ip
  description = "Public IP of the spoke Linux VM (null when disabled)"
}

output "spoke_windows_vm_id" {
  value       = module.spoke_windows_vm.vm_id
  description = "ID of the spoke Windows VM"
}

output "spoke_windows_vm_public_ip" {
  value       = module.spoke_windows_vm.public_ip
  description = "Public IP of the spoke Windows VM (null when disabled)"
}

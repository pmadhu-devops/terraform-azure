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

output "spoke_linux_vm1_id" {
  value       = module.spoke_linux_vm1.vm_id
  description = "ID of the first spoke Linux VM"
}

output "spoke_linux_vm1_public_ip" {
  value       = module.spoke_linux_vm1.public_ip
  description = "Public IP of the first spoke Linux VM (null when disabled)"
}

output "spoke_linux_vm2_id" {
  value       = module.spoke_linux_vm2.vm_id
  description = "ID of the second spoke Linux VM"
}

output "spoke_linux_vm2_public_ip" {
  value       = module.spoke_linux_vm2.public_ip
  description = "Public IP of the second spoke Linux VM (null when disabled)"
}

output "spoke_windows_vm_id" {
  value       = module.spoke_windows_vm.vm_id
  description = "ID of the spoke Windows VM"
}

output "spoke_windows_vm_public_ip" {
  value       = module.spoke_windows_vm.public_ip
  description = "Public IP of the spoke Windows VM (null when disabled)"
}

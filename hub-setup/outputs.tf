output "resource_group_id" {
  description = "ID of the created hub resource group"
  value       = module.rg.resource_group_id
}

output "vnet_id" {
  description = "ID of the created hub virtual network"
  value       = module.vnet.vnet_id
}

output "jumpservers_subnet_id" {
  description = "ID of the JumpServersSubnet"
  value       = module.vnet.subnet_ids[var.subnet_name]
}

output "nsg_id" {
  description = "ID of the hub network security group"
  value       = module.nsg.nsg_id
}

output "vm_public_ip" {
  description = "Public IP address of the hub VM"
  value       = module.vm.public_ip
}

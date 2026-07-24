output "resource_group_name" {
  description = "Resource group containing the self-hosted agent"
  value       = module.rg.resource_group_name
}

output "acr_id" {
  description = "ID of the sample vote container registry"
  value       = module.acr.id
}

output "acr_login_server" {
  description = "Login server for the sample vote container registry"
  value       = module.acr.login_server
}

output "agent_vm_id" {
  description = "ID of the self-hosted agent VM"
  value       = module.vm.vm_id
}

output "agent_vm_public_ip" {
  description = "Public IP address used to connect to the agent VM"
  value       = module.vm.public_ip
}
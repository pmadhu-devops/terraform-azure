variable "vm_name" {
  description = "Name of the Virtual Machine"
  type        = string
}

variable "location" {
  description = "Azure region for the VM"
  type        = string
}

variable "resource_group_name" {
  description = "Resource group name"
  type        = string
}

variable "subnet_id" {
  description = "Subnet ID for the VM"
  type        = string
}

variable "vm_size" {
  description = "Size of the Virtual Machine"
  type        = string
}

variable "admin_username" {
  description = "Admin username for the VM"
  type        = string
}

variable "admin_password" {
  description = "Admin password for the VM"
  type        = string
  sensitive   = true
}

variable "storage_account_type" {
  description = "Storage account type for the OS disk"
  type        = string
  default     = "StandardSSD_LRS"
}

variable "private_ip_address" {
  description = "Static private IP address to assign to the VM NIC"
  type        = string
  default     = null
}

variable "create_public_ip" {
  description = "Whether to create a public IP for the VM NIC"
  type        = bool
  default     = true
}

variable "availability_zone" {
  description = "Availability zone for the VM"
  type        = string
  default     = null
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
}

variable "custom_data" {
  description = "Base64-encoded custom data (cloud-init or script) to provision the VM at first boot"
  type        = string
  default     = null
}
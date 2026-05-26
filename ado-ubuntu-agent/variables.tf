variable "rg_name" {
  description = "Resource group name"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}

# VNet Variables
variable "vnet_name" {
  description = "Virtual network name"
  type        = string
}

variable "address_space" {
  description = "Address space for the virtual network"
  type        = list(string)
}

variable "subnets" {
  description = "Map of subnet definitions"
  type = map(object({
    address_prefixes = list(string)
  }))
}

variable "subnet_name" {
  description = "Subnet name used for VM deployment"
  type        = string
  default     = "subnet1"
}

# NSG Variables
variable "nsg_name" {
  description = "Network Security Group name"
  type        = string
}

variable "security_rules" {
  description = "NSG security rules"
  type = map(object({
    priority                   = number
    direction                  = string
    access                     = string
    protocol                   = string
    source_port_range          = string
    destination_port_range     = string
    source_address_prefix      = string
    destination_address_prefix = string
  }))
}

# VM Variables
variable "vm_name" {
  description = "Virtual machine name"
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

variable "vm_size" {
  description = "Size of the VM"
  type        = string
}

variable "storage_account_type" {
  description = "OS disk storage account type"
  type        = string
  default     = "StandardSSD_LRS"
}

variable "vm_tags" {
  description = "Tags to apply to the VM"
  type        = map(string)
  default     = {}
}
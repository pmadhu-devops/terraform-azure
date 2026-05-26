variable "rg_name" {
  description = "Resource group name for the hub setup"
  type        = string
}

variable "location" {
  description = "Azure region for the hub resources"
  type        = string
}

variable "tags" {
  description = "Tags to apply to all hub resources"
  type        = map(string)
  default     = {}
}

variable "vnet_name" {
  description = "Name of the hub virtual network"
  type        = string
}

variable "address_space" {
  description = "Address space for the hub virtual network"
  type        = list(string)
}

variable "subnets" {
  description = "Map of hub subnets"
  type = map(object({
    address_prefixes = list(string)
  }))
}

variable "subnet_name" {
  description = "Subnet used by the hub VM"
  type        = string
}

variable "nsg_name" {
  description = "Name of the hub network security group"
  type        = string
}

variable "security_rules" {
  description = "Security rules for the hub NSG"
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

variable "vm_name" {
  description = "Name of the hub Linux VM"
  type        = string
}

variable "admin_username" {
  description = "Admin username for the hub VM"
  type        = string
}

variable "admin_password" {
  description = "Admin password for the hub VM"
  type        = string
  sensitive   = true
}

variable "vm_size" {
  description = "Size of the hub VM"
  type        = string
  default     = "Standard_B1s"
}

variable "private_ip_address" {
  description = "Static private IP address for the hub VM"
  type        = string
}

variable "availability_zone" {
  description = "Availability zone for the hub VM"
  type        = string
  default     = "1"
}

variable "storage_account_type" {
  description = "OS disk storage type for the hub VM"
  type        = string
  default     = "StandardSSD_LRS"
}

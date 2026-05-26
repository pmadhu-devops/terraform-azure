variable "rg_name" {
  description = "Resource group name for spoke2 setup"
  type        = string
  default     = "AZB50-SP2-RG"
}

variable "location" {
  description = "Azure region for the spoke2 resources"
  type        = string
  default     = "westus"
}

variable "tags" {
  description = "Tags to apply to all spoke2 resources"
  type        = map(string)
  default     = {}
}

variable "address_space" {
  description = "Address space for the spoke2 VNet"
  type        = list(string)
  default     = ["172.17.0.0/16"]
}

variable "subnet1_prefixes" {
  description = "Address prefixes for subnet 1"
  type        = list(string)
  default     = ["172.17.1.0/24"]
}

variable "admin_username" {
  description = "Admin username for all VMs"
  type        = string
  default     = "adminmadhu"
}

variable "admin_password" {
  description = "Admin password for all VMs"
  type        = string
  sensitive   = true
}

variable "linux_vm_size" {
  description = "Size for the spoke Linux VM"
  type        = string
  default     = "Standard_B1s"
}

variable "windows_vm_size" {
  description = "Size for the spoke Windows VM"
  type        = string
  default     = "Standard_B2ms"
}

variable "storage_account_type" {
  description = "Storage account type for VM OS disks"
  type        = string
  default     = "StandardSSD_LRS"
}

variable "linux_vm_name" {
  description = "Name of the Linux VM"
  type        = string
  default     = "SP2-LNXSVR1"
}

variable "windows_vm_name" {
  description = "Name of the Windows VM"
  type        = string
  default     = "SP2-WINSVR1"
}

variable "linux_vm_private_ip" {
  description = "Private IP for the Linux VM"
  type        = string
  default     = "172.17.1.10"
}

variable "windows_vm_private_ip" {
  description = "Private IP for the Windows VM"
  type        = string
  default     = "172.17.1.11"
}

variable "security_rules" {
  description = "Network security rules for the spoke2 NSG"
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
  default = {
    allow_all_tcp = {
      priority                   = 100
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "*"
      source_address_prefix      = "*"
      destination_address_prefix = "*"
    }
    allow_icmp = {
      priority                   = 101
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Icmp"
      source_port_range          = "*"
      destination_port_range     = "*"
      source_address_prefix      = "*"
      destination_address_prefix = "*"
    }
  }
}

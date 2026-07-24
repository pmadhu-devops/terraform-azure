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

# ACR variables
variable "acr_name" {
  description = "Globally unique Azure Container Registry name"
  type        = string
}

variable "acr_sku" {
  description = "Azure Container Registry SKU"
  type        = string
  default     = "Basic"
}

variable "acr_admin_enabled" {
  description = "Whether to enable the Azure Container Registry local admin account"
  type        = bool
  default     = false
}

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
  description = "Subnet name used for the agent VM"
  type        = string
}

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

variable "vm_name" {
  description = "Virtual machine name"
  type        = string
}

variable "admin_username" {
  description = "Administrator username for the VM"
  type        = string
}

variable "admin_password" {
  description = "Administrator password for the VM"
  type        = string
  sensitive   = true
}

variable "vm_size" {
  description = "Size of the agent VM"
  type        = string
  default     = "Standard_B2ms"
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

variable "create_public_ip" {
  description = "Whether to create a public IP for the agent VM"
  type        = bool
  default     = true
}

variable "azure_devops_url" {
  description = "Azure DevOps organization URL, for example https://dev.azure.com/my-org"
  type        = string
}

variable "azure_devops_pat" {
  description = "Azure DevOps PAT with Agent Pools read and manage permission"
  type        = string
  sensitive   = true
}

variable "azure_devops_pool" {
  description = "Azure DevOps agent pool name"
  type        = string
  default     = "Default"
}

variable "azure_devops_agent_name" {
  description = "Name shown for this agent in Azure DevOps"
  type        = string
  default     = "ado-agent"
}

variable "azure_devops_agent_version" {
  description = "Azure Pipelines agent package version"
  type        = string
  default     = "4.255.0"
}
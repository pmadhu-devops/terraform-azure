variable "nsg_name" {
  description = "Name of the Network Security Group"
  type        = string
}
variable "location" {
  description = "Azure region for the NSG"
  type        = string
}
variable "resource_group_name" {
  description = "Resource group name"
  type        = string
}
variable "security_rules" {
  description = "Map of security rules"
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
variable "tags" {
  description = "Tags to apply to the NSG"
  type        = map(string)
  default     = {}
}
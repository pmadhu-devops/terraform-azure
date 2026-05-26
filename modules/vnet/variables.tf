variable "vnet_name" {
  description = "Name of the Virtual Network"
  type        = string
}
variable "location" {
  description = "Azure region for the VNet"
  type        = string
}
variable "resource_group_name" {
  description = "Resource group name"
  type        = string
}
variable "address_space" {
  description = "Address space for the VNet"
  type        = list(string)
}
variable "subnets" {
  description = "Map of subnets"
  type = map(object({
    address_prefixes = list(string)
  }))
}
variable "tags" {
  description = "Tags to apply to the VNet and subnets"
  type        = map(string)
  default     = {}
}
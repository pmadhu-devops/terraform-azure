variable "location" {
  description = "Azure region"
  type        = string
  default     = "westus"
}

variable "rg_name" {
  description = "Resource Group name"
  type        = string
  default     = "AZB50-SP2-RG"
}

variable "admin_username" {
  description = "Linux VM admin username"
  type        = string
  default     = "adminmadhu"
}

variable "admin_password" {
  description = "Linux VM admin password"
  type        = string
  default     = "India@123456"
}

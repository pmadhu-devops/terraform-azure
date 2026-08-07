terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=4.1.0"
    }
  }
}

provider "azurerm" {
  features {}
  # subscription_id = "a7c4673c-e710-4514-b6e1-40cf4d73da90"
}

# Backend configuration for storing Terraform state in Azure Storage Account
terraform {
  backend "azurerm" {
    resource_group_name  = "devops-rg"
    storage_account_name = "azuretfstorage01"
    container_name       = "tfstate"
    key                  = "azure.terraform.tfstate"
  }
}


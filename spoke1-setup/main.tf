module "rg" {
  source = "../modules/rg"

  rg_name  = var.rg_name
  location = var.location
  tags     = var.tags
}

module "vnet" {
  source = "../modules/vnet"

  vnet_name           = "${var.rg_name}-vNET1"
  location            = var.location
  resource_group_name = module.rg.resource_group_name
  address_space       = var.address_space
  subnets = {
    "${var.rg_name}-Subnet-1" = {
      address_prefixes = var.subnet1_prefixes
    }
    "${var.rg_name}-Subnet-2" = {
      address_prefixes = var.subnet2_prefixes
    }
  }
  tags = var.tags
}

module "nsg" {
  source = "../modules/nsg"

  nsg_name            = "${var.rg_name}_NSG1"
  location            = var.location
  resource_group_name = module.rg.resource_group_name
  security_rules      = var.security_rules
  tags                = var.tags
}

resource "azurerm_subnet_network_security_group_association" "subnet1_nsg" {
  subnet_id                 = module.vnet.subnet_ids["${var.rg_name}-Subnet-1"]
  network_security_group_id = module.nsg.nsg_id
}

resource "azurerm_subnet_network_security_group_association" "subnet2_nsg" {
  subnet_id                 = module.vnet.subnet_ids["${var.rg_name}-Subnet-2"]
  network_security_group_id = module.nsg.nsg_id
}

module "spoke_linux_vm1" {
  source = "../modules/linux-vm"

  vm_name              = var.linux_vm1_name
  location             = var.location
  resource_group_name  = module.rg.resource_group_name
  subnet_id            = module.vnet.subnet_ids["${var.rg_name}-Subnet-1"]
  vm_size              = var.linux_vm_size
  admin_username       = var.admin_username
  admin_password       = var.admin_password
  private_ip_address   = var.linux_vm1_private_ip
  create_public_ip     = false
  availability_zone    = var.availability_zone
  storage_account_type = var.storage_account_type
  tags                 = var.tags

  depends_on = [
    azurerm_subnet_network_security_group_association.subnet1_nsg,
    azurerm_subnet_network_security_group_association.subnet2_nsg,
  ]
}

# module "spoke_linux_vm2" {
#   source = "../modules/linux-vm"

#   vm_name             = var.linux_vm2_name
#   location            = var.location
#   resource_group_name = module.rg.resource_group_name
#   subnet_id           = module.vnet.subnet_ids["${var.rg_name}-Subnet-2"]
#   vm_size             = var.linux_vm_size
#   admin_username      = var.admin_username
#   admin_password      = var.admin_password
#   private_ip_address  = var.linux_vm2_private_ip
#   create_public_ip    = false
#   availability_zone   = var.availability_zone
#   storage_account_type = var.storage_account_type
#   tags                = var.tags

#   depends_on = [
#     azurerm_subnet_network_security_group_association.subnet1_nsg,
#     azurerm_subnet_network_security_group_association.subnet2_nsg,
#   ]
# }

# module "spoke_windows_vm" {
#   source = "../modules/windows-vm"

#   vm_name             = var.windows_vm_name
#   location            = var.location
#   resource_group_name = module.rg.resource_group_name
#   subnet_id           = module.vnet.subnet_ids["${var.rg_name}-Subnet-1"]
#   vm_size             = var.windows_vm_size
#   admin_username      = var.admin_username
#   admin_password      = var.admin_password
#   private_ip_address  = var.windows_vm_private_ip
#   create_public_ip    = false
#   availability_zone   = var.availability_zone
#   storage_account_type = var.storage_account_type
#   tags                = var.tags

#   depends_on = [
#     azurerm_subnet_network_security_group_association.subnet1_nsg,
#     azurerm_subnet_network_security_group_association.subnet2_nsg,
#   ]
# }

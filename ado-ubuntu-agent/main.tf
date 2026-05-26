module "rg" {
  source = "../modules/rg"

  rg_name  = var.rg_name
  location = var.location
  tags     = var.tags
}

# vNET Creation
module "vnet" {
  source              = "../modules/vnet"
  vnet_name           = var.vnet_name
  location            = var.location
  resource_group_name = module.rg.resource_group_name
  address_space       = var.address_space
  subnets             = var.subnets
  tags                = var.tags
}

# NSG Creation
module "nsg" {
  source = "../modules/nsg"

  nsg_name            = var.nsg_name
  location            = var.location
  resource_group_name = module.rg.resource_group_name

  security_rules = var.security_rules
  tags           = var.tags
}

resource "azurerm_subnet_network_security_group_association" "subnet_nsg" {
  subnet_id                 = module.vnet.subnet_ids[var.subnet_name]
  network_security_group_id = module.nsg.nsg_id
}

# VM Creation
module "vm" {
  source = "../modules/linux-vm"

  vm_name             = var.vm_name
  location            = var.location
  resource_group_name = module.rg.resource_group_name

  subnet_id = module.vnet.subnet_ids[var.subnet_name]

  vm_size = var.vm_size

  admin_username = var.admin_username
  admin_password = var.admin_password

  storage_account_type = var.storage_account_type

  tags = var.vm_tags

  depends_on = [azurerm_subnet_network_security_group_association.subnet_nsg]
}
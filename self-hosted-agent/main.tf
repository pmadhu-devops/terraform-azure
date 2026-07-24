module "rg" {
  source = "../modules/rg"

  rg_name  = var.rg_name
  location = var.location
  tags     = var.tags
}

module "acr" {
  source              = "../modules/acr"
  acr_name            = var.acr_name
  location            = var.location
  resource_group_name = module.rg.resource_group_name
  sku                 = var.acr_sku
  admin_enabled       = var.acr_admin_enabled
  tags                = var.tags
}

module "vnet" {
  source              = "../modules/vnet"
  vnet_name           = var.vnet_name
  location            = var.location
  resource_group_name = module.rg.resource_group_name
  address_space       = var.address_space
  subnets             = var.subnets
  tags                = var.tags
}

module "nsg" {
  source              = "../modules/nsg"
  nsg_name            = var.nsg_name
  location            = var.location
  resource_group_name = module.rg.resource_group_name
  security_rules      = var.security_rules
  tags                = var.tags
}

resource "azurerm_subnet_network_security_group_association" "agent_subnet" {
  subnet_id                 = module.vnet.subnet_ids[var.subnet_name]
  network_security_group_id = module.nsg.nsg_id
}

module "vm" {
  source = "../modules/linux-vm"

  vm_name              = var.vm_name
  location             = var.location
  resource_group_name  = module.rg.resource_group_name
  subnet_id            = module.vnet.subnet_ids[var.subnet_name]
  vm_size              = var.vm_size
  admin_username       = var.admin_username
  admin_password       = var.admin_password
  storage_account_type = var.storage_account_type
  create_public_ip     = var.create_public_ip
  tags                 = var.vm_tags

  custom_data = templatefile("${path.module}/scripts/install-self-hosted-agent.sh", {
    admin_username             = var.admin_username
    azure_devops_url           = var.azure_devops_url
    azure_devops_pat           = var.azure_devops_pat
    azure_devops_pool          = var.azure_devops_pool
    azure_devops_agent_name    = var.azure_devops_agent_name
    azure_devops_agent_version = var.azure_devops_agent_version
  })

  depends_on = [azurerm_subnet_network_security_group_association.agent_subnet]
}
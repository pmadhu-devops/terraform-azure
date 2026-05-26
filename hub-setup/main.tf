module "rg" {
  source = "../modules/rg"

  rg_name  = var.rg_name
  location = var.location
  tags     = var.tags
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
  source = "../modules/nsg"

  nsg_name            = var.nsg_name
  location            = var.location
  resource_group_name = module.rg.resource_group_name
  security_rules      = var.security_rules
  tags                = var.tags
}

resource "azurerm_subnet_network_security_group_association" "jumpservers" {
  subnet_id                 = module.vnet.subnet_ids[var.subnet_name]
  network_security_group_id = module.nsg.nsg_id
}

module "vm" {
  source = "../modules/linux-vm"

  vm_name             = var.vm_name
  location            = var.location
  resource_group_name = module.rg.resource_group_name
  subnet_id           = module.vnet.subnet_ids[var.subnet_name]
  vm_size             = var.vm_size
  admin_username      = var.admin_username
  admin_password      = var.admin_password
  private_ip_address  = var.private_ip_address
  availability_zone   = var.availability_zone
  storage_account_type = var.storage_account_type
  tags                = var.tags

  depends_on = [azurerm_subnet_network_security_group_association.jumpservers]
}

# Feature required: Windows VM creation
# Uncomment and provide matching variables in hub-setup/terraform.tfvars to enable.
# This block mirrors the Azure CLI example for Win2022Datacenter and Standard_B2ms.
# az vm create --resource-group ${RG} --name HUB-WINSVR1 --image Win2022Datacenter --vnet-name ${RG}-vNET1 \
#     --subnet JumpServersSubnet --admin-username adminsree --admin-password "India@123456" --size Standard_B2ms \
#     --nsg ${RG}_NSG1 --storage-sku StandardSSD_LRS --private-ip-address 10.50.1.11 \
#     --zone 1 --os-disk-delete-option Delete --nic-delete-option Delete --security-type Standard
#
# module "windows_vm" {
#   source = "../modules/windows-vm"
#
#   vm_name             = var.windows_vm_name
#   location            = var.location
#   resource_group_name = module.rg.resource_group_name
#   subnet_id           = module.vnet.subnet_ids[var.subnet_name]
#   vm_size             = "Standard_B2ms"
#   admin_username      = var.windows_admin_username
#   admin_password      = var.windows_admin_password
#   private_ip_address  = "10.50.1.11"
#   availability_zone   = "1"
#   storage_account_type = var.storage_account_type
#   tags                = var.tags
#
#   depends_on = [azurerm_subnet_network_security_group_association.jumpservers]
#}

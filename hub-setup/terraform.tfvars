rg_name  = "AZB50-HUB-RG"
location = "eastus"
tags = {
  environment = "hub"
  project     = "hub-setup"
}

vnet_name     = "AZB50-HUB-RG-vNET1"
address_space = ["10.50.0.0/16"]
subnets = {
  JumpServersSubnet = {
    address_prefixes = ["10.50.1.0/24"]
  }
  AzureFirewallSubnet = {
    address_prefixes = ["10.50.10.0/24"]
  }
  AzureBastionSubnet = {
    address_prefixes = ["10.50.20.0/24"]
  }
  GatewaySubnet = {
    address_prefixes = ["10.50.30.0/24"]
  }
  PvtEndpointSubnet = {
    address_prefixes = ["10.50.40.0/24"]
  }
}
subnet_name = "JumpServersSubnet"

nsg_name = "AZB50-HUB-RG_NSG1"
security_rules = {
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

vm_name              = "HUB-LNXSVR1"
admin_username       = "adminmadhu"
admin_password       = "India@123456"
vm_size              = "Standard_B1s"
private_ip_address   = "10.50.1.10"
availability_zone    = "1"
storage_account_type = "StandardSSD_LRS"

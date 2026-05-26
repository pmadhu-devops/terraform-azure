# RG Configurations
rg_name  = "ado-rg"
location = "centralindia"
tags = {
  ENV = "poc"
}

# Vnet and Subnet Configurations
vnet_name     = "ado-rg-vnet"
address_space = ["10.0.0.0/16"]
subnets = {
  "ado-rg-subnet" = {
    address_prefixes = ["10.0.1.0/24"]
  }
}
subnet_name = "ado-rg-subnet"

# NSG and Rules Configurations
nsg_name = "ado-rg-nsg"
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
    priority                   = 110
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Icmp"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

# VM Configurations
vm_size        = "Standard_B2s"
vm_name        = "ado-ubuntu-vm"
admin_username = "adminmadhu"
admin_password = "India@123456"
vm_tags = {
  Purpose = "ado-practice"
}
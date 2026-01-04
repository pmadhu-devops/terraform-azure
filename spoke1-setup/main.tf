# ---------------------------------
# Resource Group
# ---------------------------------
resource "azurerm_resource_group" "sp1" {
  name     = var.rg_name
  location = var.location
}

# ---------------------------------
# Virtual Network
# ---------------------------------
resource "azurerm_virtual_network" "sp1_vnet" {
  name                = "${var.rg_name}-vNET1"
  location            = azurerm_resource_group.sp1.location
  resource_group_name = azurerm_resource_group.sp1.name
  address_space       = ["172.16.0.0/16"]
}

# ---------------------------------
# Subnet 1
# ---------------------------------
resource "azurerm_subnet" "subnet1" {
  name                 = "${var.rg_name}-Subnet-1"
  resource_group_name  = azurerm_resource_group.sp1.name
  virtual_network_name = azurerm_virtual_network.sp1_vnet.name
  address_prefixes     = ["172.16.1.0/24"]
}

# ---------------------------------
# Subnet 2 (default outbound disabled)
# ---------------------------------
resource "azurerm_subnet" "subnet2" {
  name                 = "${var.rg_name}-Subnet-2"
  resource_group_name  = azurerm_resource_group.sp1.name
  virtual_network_name = azurerm_virtual_network.sp1_vnet.name
  address_prefixes     = ["172.16.2.0/24"]

  default_outbound_access_enabled = false
}

# ---------------------------------
# Network Security Group
# ---------------------------------
resource "azurerm_network_security_group" "sp1_nsg" {
  name                = "${var.rg_name}_NSG1"
  location            = azurerm_resource_group.sp1.location
  resource_group_name = azurerm_resource_group.sp1.name
}

# ---------------------------------
# NSG Rules
# ---------------------------------
resource "azurerm_network_security_rule" "allow_tcp" {
  name                        = "${var.rg_name}_NSG1_RULE1"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.sp1.name
  network_security_group_name = azurerm_network_security_group.sp1_nsg.name
}

resource "azurerm_network_security_rule" "allow_icmp" {
  name                        = "${var.rg_name}_NSG1_RULE2"
  priority                    = 101
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Icmp"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.sp1.name
  network_security_group_name = azurerm_network_security_group.sp1_nsg.name
}

# ---------------------------------
# Public IP
# ---------------------------------
resource "azurerm_public_ip" "sp1_pip" {
  name                = "SP1-LNXSVR1-pip"
  location            = azurerm_resource_group.sp1.location
  resource_group_name = azurerm_resource_group.sp1.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

# ---------------------------------
# Network Interface (Public IP attached)
# ---------------------------------
resource "azurerm_network_interface" "sp1_nic" {
  name                = "SP1-LNXSVR1-nic"
  location            = azurerm_resource_group.sp1.location
  resource_group_name = azurerm_resource_group.sp1.name

  ip_configuration {
    name                          = "ipconfig1"
    subnet_id                     = azurerm_subnet.subnet1.id
    private_ip_address_allocation = "Static"
    private_ip_address            = "172.16.1.10"
    public_ip_address_id          = azurerm_public_ip.sp1_pip.id
  }
}

# ---------------------------------
# Associate NSG to NIC
# ---------------------------------
resource "azurerm_network_interface_security_group_association" "nic_nsg" {
  network_interface_id      = azurerm_network_interface.sp1_nic.id
  network_security_group_id = azurerm_network_security_group.sp1_nsg.id
}

# ---------------------------------
# Linux Virtual Machine
# ---------------------------------
resource "azurerm_linux_virtual_machine" "sp1_vm" {
  name                = "SP1-LNXSVR1"
  location            = azurerm_resource_group.sp1.location
  resource_group_name = azurerm_resource_group.sp1.name
  size                = "Standard_B1s"
  zone                = "1"

  admin_username = var.admin_username
  admin_password = var.admin_password
  disable_password_authentication = false

  network_interface_ids = [
    azurerm_network_interface.sp1_nic.id
  ]

  os_disk {
    storage_account_type = "StandardSSD_LRS"
    caching              = "ReadWrite"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }
}

# ---------------------------------
# Resource Group
# ---------------------------------
resource "azurerm_resource_group" "sp2" {
  name     = var.rg_name
  location = var.location
}

# ---------------------------------
# Virtual Network
# ---------------------------------
resource "azurerm_virtual_network" "sp2_vnet" {
  name                = "${var.rg_name}-vNET1"
  location            = azurerm_resource_group.sp2.location
  resource_group_name = azurerm_resource_group.sp2.name
  address_space       = ["172.17.0.0/16"]
}

# ---------------------------------
# Subnet
# ---------------------------------
resource "azurerm_subnet" "subnet1" {
  name                 = "${var.rg_name}-Subnet-1"
  resource_group_name  = azurerm_resource_group.sp2.name
  virtual_network_name = azurerm_virtual_network.sp2_vnet.name
  address_prefixes     = ["172.17.1.0/24"]
}

# ---------------------------------
# Network Security Group
# ---------------------------------
resource "azurerm_network_security_group" "sp2_nsg" {
  name                = "${var.rg_name}_NSG1"
  location            = azurerm_resource_group.sp2.location
  resource_group_name = azurerm_resource_group.sp2.name
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
  resource_group_name         = azurerm_resource_group.sp2.name
  network_security_group_name = azurerm_network_security_group.sp2_nsg.name
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
  resource_group_name         = azurerm_resource_group.sp2.name
  network_security_group_name = azurerm_network_security_group.sp2_nsg.name
}

# ---------------------------------
# Public IP
# ---------------------------------
resource "azurerm_public_ip" "sp2_pip" {
  name                = "SP2-LNXSVR1-pip"
  location            = azurerm_resource_group.sp2.location
  resource_group_name = azurerm_resource_group.sp2.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

# ---------------------------------
# Network Interface (Public IP attached)
# ---------------------------------
resource "azurerm_network_interface" "sp2_nic" {
  name                = "SP2-LNXSVR1-nic"
  location            = azurerm_resource_group.sp2.location
  resource_group_name = azurerm_resource_group.sp2.name

  ip_configuration {
    name                          = "ipconfig1"
    subnet_id                     = azurerm_subnet.subnet1.id
    private_ip_address_allocation = "Static"
    private_ip_address            = "172.17.1.10"
    public_ip_address_id          = azurerm_public_ip.sp2_pip.id
  }
}

# ---------------------------------
# Associate NSG to NIC
# ---------------------------------
resource "azurerm_network_interface_security_group_association" "nic_nsg" {
  network_interface_id      = azurerm_network_interface.sp2_nic.id
  network_security_group_id = azurerm_network_security_group.sp2_nsg.id
}

# ---------------------------------
# Linux Virtual Machine
# ---------------------------------
resource "azurerm_linux_virtual_machine" "sp2_vm" {
  name                = "SP2-LNXSVR1"
  location            = azurerm_resource_group.sp2.location
  resource_group_name = azurerm_resource_group.sp2.name
  size                = "Standard_B1s"

  admin_username = var.admin_username
  admin_password = var.admin_password
  disable_password_authentication = false

  network_interface_ids = [
    azurerm_network_interface.sp2_nic.id
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

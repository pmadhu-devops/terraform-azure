data "azurerm_virtual_network" "hub" {
  name                = var.hub_vnet_name
  resource_group_name = var.hub_rg
}

data "azurerm_virtual_network" "sp1" {
  name                = var.sp1_vnet_name
  resource_group_name = var.sp1_rg
}

data "azurerm_virtual_network" "sp2" {
  name                = var.sp2_vnet_name
  resource_group_name = var.sp2_rg
}

# HUB → SP1
resource "azurerm_virtual_network_peering" "hub_to_sp1" {
  name                      = "HUB-to-SP1"
  resource_group_name       = var.hub_rg
  virtual_network_name      = data.azurerm_virtual_network.hub.name
  remote_virtual_network_id = data.azurerm_virtual_network.sp1.id

  allow_virtual_network_access = true
}

# SP1 → HUB
resource "azurerm_virtual_network_peering" "sp1_to_hub" {
  name                      = "SP1-to-HUB"
  resource_group_name       = var.sp1_rg
  virtual_network_name      = data.azurerm_virtual_network.sp1.name
  remote_virtual_network_id = data.azurerm_virtual_network.hub.id

  allow_virtual_network_access = true
}

# HUB → SP2
resource "azurerm_virtual_network_peering" "hub_to_sp2" {
  name                      = "HUB-to-SP2"
  resource_group_name       = var.hub_rg
  virtual_network_name      = data.azurerm_virtual_network.hub.name
  remote_virtual_network_id = data.azurerm_virtual_network.sp2.id

  allow_virtual_network_access = true
}

# SP2 → HUB
resource "azurerm_virtual_network_peering" "sp2_to_hub" {
  name                      = "SP2-to-HUB"
  resource_group_name       = var.sp2_rg
  virtual_network_name      = data.azurerm_virtual_network.sp2.name
  remote_virtual_network_id = data.azurerm_virtual_network.hub.id

  allow_virtual_network_access = true
}

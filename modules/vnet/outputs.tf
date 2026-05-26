output "vnet_id" {
  value = azurerm_virtual_network.this.id
  description = "ID of the created Virtual Network"
}

output "subnet_ids" {
  value = {
    for subnet_name, subnet in azurerm_subnet.this :
    subnet_name => subnet.id
  }
}
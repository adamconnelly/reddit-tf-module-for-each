resource "azurerm_subnet" "this" {
  name                 = var.name
  resource_group_name  = var.resource_group
  virtual_network_name = var.vnet
  address_prefixes     = [var.address_prefix]
}

resource "azurerm_subnet_network_security_group_association" "this" {
  subnet_id                 = azurerm_subnet.this.id
  network_security_group_id = var.nsg_id
}

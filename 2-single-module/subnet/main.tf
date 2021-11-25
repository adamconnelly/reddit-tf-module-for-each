resource "azurerm_subnet" "this" {
  name                 = var.name
  resource_group_name  = var.resource_group
  virtual_network_name = var.vnet
  address_prefixes     = [var.address_prefix]
}

resource "azurerm_network_security_group" "this" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group
}

resource "azurerm_subnet_network_security_group_association" "this" {
  subnet_id                 = azurerm_subnet.this.id
  network_security_group_id = azurerm_network_security_group.this.id
}

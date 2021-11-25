locals {
  subnets = {
    "first" : "10.0.1.0/24",
    "second" : "10.0.2.0/24",
    "third" : "10.0.3.0/24"
  }
}

resource "azurerm_resource_group" "this" {
  name     = "example-resources"
  location = "West Europe"
}

resource "azurerm_virtual_network" "this" {
  name                = "example-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
}

resource "azurerm_subnet" "this" {
  for_each             = local.subnets
  name                 = each.key
  resource_group_name  = azurerm_resource_group.this.name
  virtual_network_name = azurerm_virtual_network.this.name
  address_prefixes     = [each.value]
}

resource "azurerm_network_security_group" "this" {
  for_each            = local.subnets
  name                = each.key
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
}

resource "azurerm_subnet_network_security_group_association" "this" {
  for_each                  = local.subnets
  subnet_id                 = azurerm_subnet.this[each.key].id
  network_security_group_id = azurerm_network_security_group.this[each.key].id
}

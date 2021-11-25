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

module "nsg" {
  for_each       = local.subnets
  source         = "./nsg"
  name           = each.key
  resource_group = azurerm_resource_group.this.name
  location       = azurerm_resource_group.this.location
}

module "subnet" {
  for_each       = local.subnets
  source         = "./subnet"
  name           = each.key
  resource_group = azurerm_resource_group.this.name
  vnet           = azurerm_virtual_network.this.name
  nsg_id         = module.nsg[each.key].nsg_id
  address_prefix = each.value
}

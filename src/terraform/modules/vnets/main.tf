locals {
  network_subnets = flatten([
    for network_key, network in var.vnets : [
      for subnet in network.subnets : {
        network_key       = network_key
        name              = subnet.name
        prefix            = subnet.prefix
        service_endpoints = subnet.service_endpoints
        vnet_name         = network.vnet_name
      }
    ]
  ])
}

resource "azurerm_virtual_network" "vnets" {
  count = length(var.vnets)

  name                = var.vnets[count.index].vnet_name
  resource_group_name = var.resource_group_name
  location            = var.resource_group_location
  address_space       = var.vnets[count.index].address_space

  tags = var.tags
}

resource "azurerm_subnet" "subnets" {

  depends_on = [
    azurerm_virtual_network.vnets
  ]

  count = length(local.network_subnets)

  name                 = local.network_subnets[count.index].name
  virtual_network_name = local.network_subnets[count.index].vnet_name
  resource_group_name = var.resource_group_name
  address_prefixes     = [local.network_subnets[count.index].prefix]

  service_endpoints = local.network_subnets[count.index].service_endpoints
}


locals {
  network_subnets = flatten([
    for network_key, network in var.vnets : [
      for subnet in network.subnets : {
        vnet_name         = network.vnet_name
      }
    ]
  ])
}

data "azurerm_subnet" "gwsubnet" {
  name                 = "GatewaySubnet"
  virtual_network_name = local.network_subnets[0].vnet_name
  resource_group_name  = azurerm_resource_group.resources.name
}


module "vpngw" {
  source = "./modules/vpngw"

  count = var.vpngw ? 1 : 0


  depends_on = [
    module.vnets
  ]

  home_ip             = var.home_ip
  home_prefix         = var.home_prefix
  resource_group_name = azurerm_resource_group.resources.name
  location            = azurerm_resource_group.resources.location
  subnet_id           = data.azurerm_subnet.gwsubnet.id

  tags = var.tags
}

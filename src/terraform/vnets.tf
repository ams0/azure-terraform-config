module "vnets" {
  source = "./modules/vnets"

  resource_group_name     = azurerm_resource_group.resources.name
  resource_group_location = azurerm_resource_group.resources.location
  vnets                   = var.vnets
  tags                    = var.tags
}


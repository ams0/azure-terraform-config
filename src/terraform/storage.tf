module "storage" {
  source = "./modules/storage"

  count = var.storage ? 1 : 0

  resource_group_name = azurerm_resource_group.resources.name
  location            = azurerm_resource_group.resources.location
  storage_name        = var.storage_name
  home_ip             = var.home_ip
  tags                = var.tags
}

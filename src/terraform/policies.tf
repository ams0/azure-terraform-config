module "azure-policy" {
  source   = "./modules/azure-policy"
  location = azurerm_resource_group.resources.location
}

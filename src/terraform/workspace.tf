# module "workspace" {
#   source = "./modules/log-analytics"

#   resource_group_name = azurerm_resource_group.resources.name
#   location            = azurerm_resource_group.resources.location
#   workspace_name      = "monitoring"
#   tags                = var.tags
# }

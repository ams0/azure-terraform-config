resource "azurerm_container_registry" "acr" {
  name                = var.acr_name
  resource_group_name = azurerm_resource_group.resources.name
  location            = azurerm_resource_group.resources.location
  sku                 = var.acr_sku
  admin_enabled       = false
#   georeplications {
#     location                  = var.acr_alternate_location
#     zone_redundancy_enabled   = false
#     regional_endpoint_enabled = true
#     tags                      = var.tags
#   }

  tags = var.tags

}
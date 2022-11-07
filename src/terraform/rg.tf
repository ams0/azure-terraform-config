resource "azurerm_resource_group" "resources" {
  name     = var.resources_rg_name
  location = var.resources_rg_location

  tags = var.tags
}

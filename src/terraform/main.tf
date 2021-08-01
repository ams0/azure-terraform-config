resource "azurerm_resource_group" "example" {
  name     = var.main_rg_name
  location = var.main_rg_location
}

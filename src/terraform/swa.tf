resource "azurerm_static_site" "swa" {
  name                = "swa"
  resource_group_name = azurerm_resource_group.resources.name
  location            = azurerm_resource_group.resources.location
}

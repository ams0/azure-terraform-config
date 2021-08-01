resource "azurerm_resource_group" "resources" {
  name     = var.main_rg_name
  location = var.main_rg_location

  tags = var.tags
}

resource "azurerm_ssh_public_key" "pubkey" {
  name                = "pubkey"
  resource_group_name = azurerm_resource_group.resources.name
  location            = azurerm_resource_group.resources.location
  public_key          = var.pubkey

  tags = var.tags

}

resource "azurerm_virtual_network" "k8svnet" {
  name                = var.k8svnet_name
  resource_group_name = azurerm_resource_group.resources.name
  location            = azurerm_resource_group.resources.location
  address_space       = var.k8svnet_space

  tags = var.tags

}

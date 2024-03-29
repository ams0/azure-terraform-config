resource "azurerm_ssh_public_key" "pubkey" {
  name                = "pubkey"
  resource_group_name = azurerm_resource_group.resources.name
  location            = azurerm_resource_group.resources.location
  public_key          = var.pubkey

  tags = var.tags
}

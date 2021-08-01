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

resource "azurerm_virtual_network" "vnets" {
  count = length(var.vnets)

  name                = var.vnets[count.index].vnet_name
  resource_group_name = azurerm_resource_group.resources.name
  location            = azurerm_resource_group.resources.location
  address_space       = var.vnets[count.index].address_space

  dynamic "subnet" {
    for_each = var.vnets[count.index].subnets

    content {
      name           = subnet.value.name
      address_prefix = subnet.value.address
    }
  }

  tags = var.tags

}


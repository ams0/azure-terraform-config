resource "azurerm_public_ip" "bastion" {
  name                = "bastion"
  resource_group_name = azurerm_resource_group.resources.name
  location            = azurerm_resource_group.resources.location
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_bastion_host" "k8s-bastion" {
  name                = "k8s-bastion"
  resource_group_name = azurerm_resource_group.resources.name
  location            = azurerm_resource_group.resources.location

  ip_configuration {
    name                 = "k8s-bastion"
    subnet_id            = azurerm_subnet.subnets["bastion"].id
    public_ip_address_id = azurerm_public_ip.bastion.id
  }
}

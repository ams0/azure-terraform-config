resource "azurerm_resource_group" "monitoring" {
  name     = "monitoring"
  location = var.main_rg_location

  tags = var.tags
}

data "azurerm_subnet" "vms" {
  name                 = "vms"
  virtual_network_name = "k8svnet"
  resource_group_name  = azurerm_resource_group.resources.name
}

resource "azurerm_network_interface" "monitoring" {
  name                = "monitoring-nic"
  location            = var.main_rg_location
  resource_group_name = azurerm_resource_group.monitoring.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = data.azurerm_subnet.monitoring.id
    private_ip_address_allocation = "Dynamic"
  }
}
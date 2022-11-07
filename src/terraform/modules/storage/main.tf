resource "azurerm_storage_account" "mainstorage" {
  name                     = var.storage_name
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  nfsv3_enabled             = false
  enable_https_traffic_only = true
  is_hns_enabled            = true
  network_rules {
    default_action = "Allow"
    ip_rules       = [var.home_ip]
    #virtual_network_subnet_ids = [azurerm_virtual_network.vnets[0].subnet.*.id[2]]
  }
  tags = var.tags
}

resource "azurerm_storage_share" "cloudshell" {
  name                 = "cloudshell"
  storage_account_name = azurerm_storage_account.mainstorage.name
  quota                = 50
}
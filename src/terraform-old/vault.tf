resource "azurerm_data_protection_backup_vault" "vault" {
  name                = "vault"
  resource_group_name = azurerm_resource_group.resources.name
  location            = azurerm_resource_group.resources.location
  datastore_type      = "VaultStore"
  redundancy          = "LocallyRedundant"
}
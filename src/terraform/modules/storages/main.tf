locals {
  containers_account = flatten([
    for account_key, account in var.storages : [
      for containers in account.containers : {
        account_key           = account_key
        name                  = containers.name
        account_name          = account.name
        container_access_type = containers.container_access_type
      }
    ]
  ])
  vnet = flatten([
    for account_key, account in var.storages : [
      for vnet in account.vnet : {
        account_key    = account_key
        account_name   = account.name
        vnet_name      = vnet.name
        subnet_name    = vnet.subnet
        resource_group = vnet.resource_group
      }
    ]
  ])
}

resource "azurerm_storage_account" "storages" {

  resource_group_name = var.resource_group_name
  location            = var.location

  for_each = var.storages

  name = each.value.name

  account_tier             = each.value.tier
  account_replication_type = each.value.type
  access_tier              = each.value.access_tier
  account_kind             = each.value.account_kind
  network_rules {
    default_action             = "Deny"
    virtual_network_subnet_ids = var.virtual_network_subnet_ids
  }

  share_properties {
    retention_policy {
      days = 7
    }
  }
  queue_properties {

    hour_metrics {
      enabled               = true
      include_apis          = true
      retention_policy_days = 7
      version               = "1.0"
    }

    logging {
      delete                = false
      read                  = false
      retention_policy_days = 1
      version               = "1.0"
      write                 = false
    }

    minute_metrics {
      enabled               = false
      include_apis          = false
      retention_policy_days = 1
      version               = "1.0"
    }
  }
  tags = var.tags

}


resource "azurerm_storage_container" "containers" {

  depends_on = [
    azurerm_storage_account.storages
  ]
  for_each = {
    for ns in local.containers_account : "${ns.account_key}.${ns.name}" => ns
  }

  name                  = each.value.name
  storage_account_name  = each.value.account_name
  container_access_type = each.value.container_access_type
}

#this implementation is not complete yet! We need a way to look up subnets ids based on the vnet array in the storages variable and pass it when the storage account is created
data "azurerm_subnet" "pvtesubnet" {

  for_each = {
    for vnet in local.vnet : "${vnet.account_key}.${vnet.subnet_name}" => vnet
  }


  name                 = each.value.subnet_name
  virtual_network_name = each.value.vnet_name
  resource_group_name  = each.value.resource_group
}


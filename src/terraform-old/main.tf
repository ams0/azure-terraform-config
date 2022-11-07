locals {
  network_subnets = flatten([
    for network_key, network in var.vnets : [
      for subnet in network.subnets : {
        network_key       = network_key
        name              = subnet.name
        prefix            = subnet.prefix
        service_endpoints = subnet.service_endpoints
        vnet_name         = network.vnet_name
      }
    ]
  ])
}


resource "azurerm_resource_group" "resources" {
  name     = var.resources_rg_name
  location = var.resources_rg_location

  tags = var.tags
}

resource "azurerm_resource_group" "vms" {
  name     = "vms"
  location = var.resources_rg_location

  tags = var.tags
}

resource "azurerm_resource_group" "aks" {
  name     = "aks"
  location = var.resources_rg_location

  tags = var.tags
}



resource "azurerm_ssh_public_key" "pubkey" {
  name                = "pubkey"
  resource_group_name = azurerm_resource_group.resources.name
  location            = azurerm_resource_group.resources.location
  public_key          = var.pubkey

  tags = var.tags
}

resource "azurerm_storage_account" "mainstorage" {
  name                     = var.storage_name
  resource_group_name      = azurerm_resource_group.resources.name
  location                 = azurerm_resource_group.resources.location
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


resource "azurerm_virtual_network" "vnets" {
  count = length(var.vnets)

  name                = var.vnets[count.index].vnet_name
  resource_group_name = azurerm_resource_group.resources.name
  location            = azurerm_resource_group.resources.location
  address_space       = var.vnets[count.index].address_space

  tags = var.tags
}

resource "azurerm_subnet" "subnets" {

  depends_on = [
    azurerm_virtual_network.vnets
  ]

  count = length(local.network_subnets)

  name                 = local.network_subnets[count.index].name
  virtual_network_name = local.network_subnets[count.index].vnet_name
  resource_group_name  = azurerm_resource_group.resources.name
  address_prefixes     = [local.network_subnets[count.index].prefix]

  service_endpoints = local.network_subnets[count.index].service_endpoints
}

resource "azurerm_user_assigned_identity" "aks" {
  resource_group_name = azurerm_resource_group.resources.name
  location            = azurerm_resource_group.resources.location

  name = "aks"
}

resource "azurerm_user_assigned_identity" "aksnodepool" {
  resource_group_name = azurerm_resource_group.resources.name
  location            = azurerm_resource_group.resources.location

  name = "aksnodepool"
}

resource "azurerm_role_assignment" "vmcaks" {
  scope                = azurerm_resource_group.resources.id
  role_definition_name = "Virtual Machine Contributor"
  principal_id         = azurerm_user_assigned_identity.aks.principal_id
}

resource "azurerm_container_registry" "acr" {
  name                = "theregistry"
  resource_group_name = azurerm_resource_group.resources.name
  location            = azurerm_resource_group.resources.location
  sku                 = "Premium"
  admin_enabled       = false
  georeplications {
    location                  = "West US 2"
    zone_redundancy_enabled   = false
    regional_endpoint_enabled = true
    tags                      = var.tags
  }

  tags = var.tags

}

data "azurerm_resource_group" "dns" {
  name = "dns"
}
resource "azurerm_role_assignment" "dns" {
  scope                = data.azurerm_resource_group.dns.id
  role_definition_name = "DNS Zone Contributor"
  principal_id         = azurerm_user_assigned_identity.aksnodepool.principal_id
}

resource "azurerm_managed_disk" "prometheus" {
  name                 = "prometheus-metrics"
  resource_group_name  = azurerm_resource_group.resources.name
  location             = azurerm_resource_group.resources.location
  storage_account_type = "Standard_LRS"
  create_option        = "Empty"
  disk_size_gb         = var.prometheus_disk_size

  tags = var.tags

}

resource "azurerm_management_lock" "prometheus" {
  name       = "prometheus"
  scope      = azurerm_managed_disk.prometheus.id
  lock_level = "CanNotDelete"
  notes      = "Prometheus state"
}

resource "azurerm_managed_disk" "loki" {
  name                 = "loki-storage"
  resource_group_name  = azurerm_resource_group.resources.name
  location             = azurerm_resource_group.resources.location
  storage_account_type = "Standard_LRS"
  create_option        = "Empty"
  disk_size_gb         = var.loki_disk_size

  tags = var.tags

}

module "vpngw" {
  source = "./modules/vpngw"

  depends_on = [
    azurerm_subnet.subnets
  ]

  home_ip             = var.home_ip
  home_prefix         = var.home_prefix
  resource_group_name = azurerm_resource_group.resources.name
  location            = azurerm_resource_group.resources.location
  subnet_id           = azurerm_subnet.subnets[0].id

  tags = var.tags
}

# module "storages" {
#   source = "../../modules/storages"

#   environment                = var.environment
#   app_name                   = var.app_name
#   location                   = var.location
#   resource_group_name        = data.azurerm_resource_group.rg.name
#   virtual_network_subnet_ids = [data.azurerm_subnet.akssubnet.id, data.azurerm_subnet.jenkins.id]

#   storages = var.storages

#   tags = local.common_tags
# }

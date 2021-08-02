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

resource "azurerm_public_ip" "vnetgwip" {
  name                = "vnetgwip"
  resource_group_name = azurerm_resource_group.resources.name
  location            = azurerm_resource_group.resources.location

  allocation_method = "Dynamic"

  tags = var.tags

}

resource "azurerm_local_network_gateway" "home" {
  name                = "home"
  resource_group_name = azurerm_resource_group.resources.name
  location            = azurerm_resource_group.resources.location
  gateway_address     = var.home_ip
  address_space       = ["192.168.178.0/24"]
}

resource "azurerm_virtual_network_gateway" "vpngw" {

  depends_on = [
    azurerm_subnet.subnets
  ]
  name                = "vpngw"
  resource_group_name = azurerm_resource_group.resources.name
  location            = azurerm_resource_group.resources.location

  type     = "Vpn"
  vpn_type = "RouteBased"

  active_active = false
  enable_bgp    = false
  sku           = "VpnGw1"

  ip_configuration {
    name                          = "vnetGatewayConfig"
    public_ip_address_id          = azurerm_public_ip.vnetgwip.id
    private_ip_address_allocation = "Dynamic"
    subnet_id                     = azurerm_subnet.subnets[0].id
  }

  tags = var.tags

}

resource "random_string" "sharedsecret" {
  length  = 16
  special = true
}

resource "azurerm_virtual_network_gateway_connection" "homevpn" {
  name                = "homevpn"
  resource_group_name = azurerm_resource_group.resources.name
  location            = azurerm_resource_group.resources.location

  type                       = "IPsec"
  virtual_network_gateway_id = azurerm_virtual_network_gateway.vpngw.id
  local_network_gateway_id   = azurerm_local_network_gateway.home.id

  shared_key = random_string.sharedsecret.result

}

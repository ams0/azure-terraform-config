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

  nfsv3_enabled             = true
  enable_https_traffic_only = false
  is_hns_enabled            = true

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

  dynamic "subnet" {
    for_each = var.vnets[count.index].subnets

    content {
      name           = subnet.value.name
      address_prefix = subnet.value.address
    }
  }

  tags = var.tags

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
  name                = "vpngw"
  resource_group_name = azurerm_resource_group.resources.name
  location            = azurerm_resource_group.resources.location

  type     = "Vpn"
  vpn_type = "RouteBased"

  active_active = false
  enable_bgp    = false
  sku           = "Basic"

  ip_configuration {
    name                          = "vnetGatewayConfig"
    public_ip_address_id          = azurerm_public_ip.vnetgwip.id
    private_ip_address_allocation = "Dynamic"
    subnet_id                     = azurerm_virtual_network.vnets[0].subnet.*.id[0]
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

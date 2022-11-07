resource "azurerm_public_ip" "vnetgwip" {
  name                = "vnetgwip"
  resource_group_name = var.resource_group_name
  location            = var.location

  allocation_method = "Dynamic"

  tags = var.tags

}

resource "azurerm_local_network_gateway" "home" {
  name                = "home"
  resource_group_name = var.resource_group_name
  location            = var.location
  gateway_address     = var.home_ip
  address_space       = var.home_prefix
}

resource "azurerm_virtual_network_gateway" "vpngw" {


  name                = "vpngw"
  resource_group_name = var.resource_group_name
  location            = var.location

  type     = "Vpn"
  vpn_type = "RouteBased"

  active_active = false
  enable_bgp    = false
  sku           = "VpnGw1"

  ip_configuration {
    name                          = "vnetGatewayConfig"
    public_ip_address_id          = azurerm_public_ip.vnetgwip.id
    private_ip_address_allocation = "Dynamic"
    subnet_id                     = var.subnet_id
  }

  tags = var.tags

}

resource "random_string" "sharedsecret" {
  length  = 16
  special = true
}

resource "azurerm_virtual_network_gateway_connection" "homevpn" {
  name                = "homevpn"
  resource_group_name = var.resource_group_name
  location            = var.location

  type                       = "IPsec"
  virtual_network_gateway_id = azurerm_virtual_network_gateway.vpngw.id
  local_network_gateway_id   = azurerm_local_network_gateway.home.id

  shared_key = random_string.sharedsecret.result

}
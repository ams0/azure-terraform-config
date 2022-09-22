data "azurerm_resource_group" "rg" {
  name = var.resource_group_name
}

resource "azurerm_dns_zone" "zone" {
  name                = var.zone_name
  resource_group_name = data.azurerm_resource_group.rg.name
  tags                = var.tags
}

resource "azurerm_dns_a_record" "arecord" {

  for_each = var.arecords

  name                = each.key
  zone_name           = var.zone_name
  resource_group_name = data.azurerm_resource_group.rg.name
  ttl                 = 300
  records             = each.value
}

resource "azurerm_dns_mx_record" "mxrecord" {

  for_each = var.mxrecords

  name                = each.key
  zone_name           = var.zone_name
  resource_group_name = data.azurerm_resource_group.rg.name
  ttl                 = 300
  record {
    preference = each.value
    exchange   = each.key
  }
}


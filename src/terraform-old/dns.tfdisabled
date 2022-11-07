module "dns" {
  source = "./modules/dns"
  count  = length(var.zones)

  resource_group_name = data.azurerm_resource_group.dns.name

  zone_name = var.zones[count.index].zone_name
  arecords   = var.zones[count.index].arecords
  mxrecords   = var.zones[count.index].mxrecords
  tags      = var.tags
}
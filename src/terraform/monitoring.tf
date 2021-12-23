resource "azurerm_resource_group" "monitoring" {
  name     = var.monitoring_rg_name
  location = var.monitoring_rg_location

  tags = var.tags
}

# module "loganalytics" {
#   source  = "./modules/loganalytics"
#   rg_name = azurerm_resource_group.monitoring.name
#   ws_name = "logws"

#   tags = var.tags

# }

module "workspace" {
    source = "avinor/log-analytics/azurerm"

  name                = "common"
  resource_group_name = "test"
  location            = "westeurope"

  solutions = [
    {
      solution_name = "ContainerInsights",
      publisher     = "Microsoft",
      product       = "OMSGallery/ContainerInsights",
    },
  ]
}
module "monitoring" {
  source = "./modules/vm"

  count = var.monitoring_vm ? 1 : 0

  rg_name     = "vms"
  rg_location = var.resources_rg_location

  vm_name = "monitoring"

  tags = var.tags
}

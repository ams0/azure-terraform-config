module "workspace" {
  source = "avinor/log-analytics/azurerm"

  name                = var.logws_name
  resource_group_name = var.monitoring_rg_name
  location            = var.monitoring_rg_location

  sku  = "PerGB2018"
  tags = var.tags

  solutions = [
    {
      solution_name = "ContainerInsights",
      publisher     = "Microsoft",
      product       = "OMSGallery/ContainerInsights",
    },
    {
      solution_name = "VMInsights",
      publisher     = "Microsoft",
      product       = "OMSGallery/VMInsights",
    },
  ]
}

module "monitoringvm" {
  source = "./modules/vm"

  count = var.monitoring_vm ? 1 : 0

  rg_name     = "vms"
  rg_location = var.resources_rg_location

  vm_name = "monitoring"

  tags = var.tags
}

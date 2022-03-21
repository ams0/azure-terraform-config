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

    {
      solution_name = "ServiceMap",
      publisher     = "Microsoft",
      product       = "OMSGallery/ServiceMap",
    },
    {
      solution_name = "SecurityCenterFree",
      publisher     = "Microsoft",
      product       = "OMSGallery/SecurityCenterFree",
    },
    {
      solution_name = "AzureActivity",
      publisher     = "Microsoft",
      product       = "OMSGallery/AzureActivity",
    },

    {
      solution_name = "NetworkMonitoring",
      publisher     = "Microsoft",
      product       = "OMSGallery/NetworkMonitoring",
    },
    {
      solution_name = "Security",
      publisher     = "Microsoft",
      product       = "OMSGallery/Security",
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

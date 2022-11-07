module "workspace" {
  source = "avinor/log-analytics/azurerm"

  name                = var.workspace_name
  resource_group_name = var.resource_group_name
  location            = var.location

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

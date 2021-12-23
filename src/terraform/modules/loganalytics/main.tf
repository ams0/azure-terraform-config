data "azurerm_resource_group" "log" {
  name = var.rg_name
}

resource "azurerm_log_analytics_workspace" "logws" {
  name                = var.ws_name
  location            = data.azurerm_resource_group.log.location
  resource_group_name = data.azurerm_resource_group.log.name
  sku                 = "PerGB2018"
  retention_in_days   = 30
}

resource "azurerm_log_analytics_solution" "vm_insights" {
  solution_name         = "VMInsights(${var.ws_name})"
  location              = data.azurerm_resource_group.log.location
  resource_group_name   = data.azurerm_resource_group.log.name
  workspace_resource_id = azurerm_log_analytics_workspace.logws.workspace_id
  workspace_name        = azurerm_log_analytics_workspace.logws.name


  plan {
    product   = "Microsoft"
    publisher = "OMSGallery/VMInsights"
  }
}

resource "azurerm_log_analytics_solution" "containers" {
  solution_name         = "ContainerInsights(${var.ws_name})"
  location              = data.azurerm_resource_group.log.location
  resource_group_name   = data.azurerm_resource_group.log.name
  workspace_resource_id = azurerm_log_analytics_workspace.logws.workspace_id
  workspace_name        = azurerm_log_analytics_workspace.logws.name

  plan {
    publisher = "Microsoft"
    product   = "OMSGallery/ContainerInsights"
  }
}

# resource "azurerm_log_analytics_solution" "network" {
#   solution_name         = "NetworkInsights"
#   location              = data.azurerm_resource_group.log.location
#   resource_group_name   = data.azurerm_resource_group.log.name
#   workspace_resource_id = azurerm_log_analytics_workspace.logws.workspace_id
#   workspace_name        = "logws"

#   plan {
#     publisher = "Microsoft"
#     product   = "OMSGallery/NetworkMonitoring"
#   }
# }

# resource "azurerm_log_analytics_solution" "security" {
#   solution_name         = "SecurityInsights"
#   location              = data.azurerm_resource_group.log.location
#   resource_group_name   = data.azurerm_resource_group.log.name
#   workspace_resource_id = azurerm_log_analytics_workspace.logws.workspace_id
#   workspace_name        = "logws"

#   plan {
#     publisher = "Microsoft"
#     product   = "OMSGallery/Security"
#   }
# }

# resource "azurerm_log_analytics_solution" "azactivity" {
#   solution_name         = "AzureActivityInsights"
#   location              = data.azurerm_resource_group.log.location
#   resource_group_name   = data.azurerm_resource_group.log.name
#   workspace_resource_id = azurerm_log_analytics_workspace.logws.workspace_id
#   workspace_name        = "logws"

#   plan {
#     publisher = "Microsoft"
#     product   = "OMSGallery/AzureActivity"
#   }
# }

# resource "azurerm_log_analytics_solution" "VMInsights" {
#   solution_name         = "VMInsights"
#   location              = data.azurerm_resource_group.log.location
#   resource_group_name   = data.azurerm_resource_group.log.name
#   workspace_resource_id = azurerm_log_analytics_workspace.logws.workspace_id
#   workspace_name        = "logws"

#   plan {
#     publisher = "Microsoft"
#     product   = "OMSGallery/VMInsights"
#   }
# }

# resource "azurerm_log_analytics_solution" "SecurityCenterFree" {
#   solution_name         = "SecurityCenterFree"
#   location              = data.azurerm_resource_group.log.location
#   resource_group_name   = data.azurerm_resource_group.log.name
#   workspace_resource_id = azurerm_log_analytics_workspace.logws.workspace_id
#   workspace_name        = "logws"

#   plan {
#     publisher = "Microsoft"
#     product   = "OMSGallery/SecurityCenterFree"
#   }
# }

# resource "azurerm_log_analytics_solution" "ServiceMap" {
#   solution_name         = "ServiceMap"
#   location              = data.azurerm_resource_group.log.location
#   resource_group_name   = data.azurerm_resource_group.log.name
#   workspace_resource_id = azurerm_log_analytics_workspace.logws.workspace_id
#   workspace_name        = "logws"

#   plan {
#     publisher = "Microsoft"
#     product   = "OMSGallery/ServiceMap"
#   }
# }

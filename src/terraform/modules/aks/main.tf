data "azurerm_resource_group" "aks" {
  name = var.rg_name
}

data "azurerm_resource_group" "resources" {
  name = "resources"
}

resource "azurerm_kubernetes_cluster" "aks1" {
  name                = var.dns_prefix
  location            = data.azurerm_resource_group.resources.location
  resource_group_name = data.azurerm_resource_group.aks.name
  dns_prefix          = var.dns_prefix
  kubernetes_version  = var.kubernetes_version

  default_node_pool {
    name       = "system"
    node_count = var.default_pool_vm_count
    vm_size    = var.default_pool_vm_size

    vnet_subnet_id = var.vnet_subnet_id
  }

  addon_profile {
    oms_agent {
      enabled = false
    }
  }
  kubelet_identity {
    client_id                 = var.nodepool_client_id
    object_id                 = var.nodepool_object_id
    user_assigned_identity_id = var.nodepool_user_assigned_identity_id
  }
  identity {
    type                      = "UserAssigned"
    user_assigned_identity_id = var.user_assigned_identity_id
  }

  network_profile {
    network_plugin = "kubenet"
    network_policy = "calico"
  }
  tags = var.tags

}

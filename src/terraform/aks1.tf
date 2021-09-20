resource "azurerm_kubernetes_cluster" "aks1" {
  name                = "aks1"
  location            = var.main_rg_location
  resource_group_name = azurerm_resource_group.aks.name
  dns_prefix          = "aks1"
  kubernetes_version  = "1.21.2"

  default_node_pool {
    name           = "default"
    node_count     = 2
    vm_size        = "Standard_B4ms"
    vnet_subnet_id = azurerm_subnet.subnets[3].id
  }

  kubelet_identity {
    user_assigned_identity_id = azurerm_user_assigned_identity.aksnodepool.id
  }
  identity {
    type                      = "UserAssigned"
    user_assigned_identity_id = azurerm_user_assigned_identity.aks.id
  }

  network_profile {
    network_plugin = "kubenet"
    network_policy = "calico"
  }
  tags = var.tags

}

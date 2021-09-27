module "aks1" {
  source = "./modules/aks"

  count = var.aks1 ? 1 : 0

  dns_prefix         = "aks1"
  kubernetes_version = "1.21.2"

  #3 = aks1
  #4 = aks2
  vnet_subnet_id = azurerm_subnet.subnets[3].id

  nodepool_client_id                 = azurerm_user_assigned_identity.aksnodepool.client_id
  nodepool_object_id                 = azurerm_user_assigned_identity.aksnodepool.principal_id
  nodepool_user_assigned_identity_id = azurerm_user_assigned_identity.aksnodepool.id

  user_assigned_identity_id = azurerm_user_assigned_identity.aks.id

  tags = var.tags
}

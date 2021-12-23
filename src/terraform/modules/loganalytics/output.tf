output "logwsprimarykey" {
  value = azurerm_log_analytics_workspace.logws.primary_shared_key 
}

output "wsid" {
  value = azurerm_log_analytics_workspace.logws.workspace_id  
}

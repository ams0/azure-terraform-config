data "azurerm_subscription" "current" {}

resource "azurerm_subscription_policy_assignment" "azpolicy-addon-to-aks" {
  name                 = "azpolicy-to-aks"
  policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/0a15ec92-a229-4763-bb14-0ea34a568f8d"
  subscription_id      = data.azurerm_subscription.current.id
  display_name         = "Azure Policy Add-on for Kubernetes service (AKS) should be installed and enabled on your clusters - TF"


  parameters = <<PARAMETERS
    {
      "Effect": {
        "value: "Audit"
      }
    }
    PARAMETERS
}


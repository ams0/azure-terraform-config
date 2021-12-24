data "azurerm_subscription" "current" {}

resource "azurerm_subscription_policy_assignment" "azpolicy-addon-enabled-aks" {
  name                 = "azpolicy-to-aks"
  policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/0a15ec92-a229-4763-bb14-0ea34a568f8d"
  subscription_id      = data.azurerm_subscription.current.id
  display_name         = "Azure Policy Add-on for Kubernetes service (AKS) should be installed and enabled on your clusters - TF"

  parameters = <<PARAMETERS
        {
            "effect": {
                "value" : "Audit"
            }
        }
        PARAMETERS
}

resource "azurerm_subscription_policy_assignment" "azpolicy-addon-deploy-aks" {
  name                 = "azpolicy-deploy-aks"
  policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/a8eff44f-8c92-45c3-a3fb-9880802d67a7"
  subscription_id      = data.azurerm_subscription.current.id
  display_name         = "Deploy Azure Policy Add-on to Azure Kubernetes Service clusters - TF"
  location             = var.resources_rg_location

  parameters = jsonencode({
    "effect" : {
      "value" : "Disabled",
    },
  })
  identity {
    type = "SystemAssigned"
  }
}

resource "azurerm_subscription_policy_assignment" "k8s-secbaseline" {
  name                 = "k8s-secbaseline"
  policy_definition_id = "/providers/Microsoft.Authorization/policySetDefinitions/a8640138-9b0a-4a28-b8cb-1666c838647d"
  subscription_id      = data.azurerm_subscription.current.id
  display_name         = "Kubernetes cluster pod security baseline standards for Linux-based workloads- TF"

  parameters = jsonencode({
    "effect" : {
      "value" : "audit",
    },
    "excludedNamespaces" : {
      "value" : [
        "kube-system",
        "gatekeeper-system",
        "azure-arc",
        "argocd",
        "cert-manager",
        "ingress",
        "monitoring",
        "flux-system",
        "cert-manager"
      ]
    }
  })
}

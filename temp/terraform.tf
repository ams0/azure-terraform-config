terraform {
  required_version = ">= 1.0.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 2.89.0"
    }
  }
  backend "azurerm" {
    use_microsoft_graph  = true
    container_name       = "tfstates"
    storage_account_name = "tfstateblobs"
    resource_group_name  = "tfstates"
    key                  = "tempstate"
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg" {
  name     = "temprg"
  location = "westeurope"
}

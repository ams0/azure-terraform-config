vnets = [
  {
    vnet_name     = "k8svnet"
    address_space = ["172.20.0.0/16"]
    subnets = [
      {
        name              = "GatewaySubnet"
        prefix            = "172.20.1.0/24"
        service_endpoints = []
      },
      {
        name              = "VMs"
        prefix            = "172.20.10.0/24"
        service_endpoints = []

      },
      {
        name              = "Storage"
        prefix            = "172.20.8.0/24"
        service_endpoints = ["Microsoft.Storage"]
      },
      {
        name              = "aks1"
        prefix            = "172.20.11.0/24"
        service_endpoints = ["Microsoft.Storage"]
      },
      {
        name              = "aks2"
        prefix            = "172.20.12.0/24"
        service_endpoints = ["Microsoft.Storage"]
      },
      {
        name              = "aks3"
        prefix            = "172.20.13.0/24"
        service_endpoints = ["Microsoft.Storage"]
      },
      {
        name              = "aks4"
        prefix            = "172.20.14.0/24"
        service_endpoints = ["Microsoft.Storage"]
      },
      {
        name              = "aks5"
        prefix            = "172.20.15.0/24"
        service_endpoints = ["Microsoft.Storage"]
      },
      {
        name              = "aks6"
        prefix            = "172.20.16.0/24"
        service_endpoints = ["Microsoft.Storage"]
      },
      {
        name              = "AzureBastionSubnet"
        prefix            = "172.20.254.0/24"
        service_endpoints = []
      },
    ]
  }
]
tags = {
  "createdby"  = "tfcloud"
  "persistent" = "true"
}
resources_rg_name     = "resources"
resources_rg_location = "westeurope"
pubkey                = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDIOxg+goSYoCIND3IIAjPoPGr7gsux9OQjE5IP2wEU8eMsywgGXBwZXUVjh8NgFHVWZEMTQCAM52P2ipYBup9QhuqWVjH4v0hrj1X/rx7tzlZh2wk3kgVPQwMKCyacQLifqus4quJLSQAPu1ksgxaWEBWnSa0e+DM2D0PYs/j284qOO9T9ULqpb/ZJK9gySa+AfSMhGCskcT/EfE8g1iqC96PajFxGHOBxqiDFtIKPhNiqKYruDhVJYmhAXG6ScHadiXzP3BdiPR66eyCOQtSeIxjnEeJcrZ7vZLFpWQvaaZw+JfPkGGFCsBTn39dfr1awrMtPIPvkj4iU1jkGKzUD alessandro"

monitoring_vm = false
aks1 = true

storage_name = "storeme"

prometheus_disk_size = 10
loki_disk_size       = 10

home_prefix = ["192.168.178.0/24"]

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
      }
    ]
  }
]

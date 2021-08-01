tags = {
  "createdby"  = "tfcloud"
  "persistent" = "true"
}
main_rg_name     = "resources"
main_rg_location = "westeurope"
pubkey           = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDIOxg+goSYoCIND3IIAjPoPGr7gsux9OQjE5IP2wEU8eMsywgGXBwZXUVjh8NgFHVWZEMTQCAM52P2ipYBup9QhuqWVjH4v0hrj1X/rx7tzlZh2wk3kgVPQwMKCyacQLifqus4quJLSQAPu1ksgxaWEBWnSa0e+DM2D0PYs/j284qOO9T9ULqpb/ZJK9gySa+AfSMhGCskcT/EfE8g1iqC96PajFxGHOBxqiDFtIKPhNiqKYruDhVJYmhAXG6ScHadiXzP3BdiPR66eyCOQtSeIxjnEeJcrZ7vZLFpWQvaaZw+JfPkGGFCsBTn39dfr1awrMtPIPvkj4iU1jkGKzUD alessandro"

vnets = [
  {
    vnet_name     = "k8svnet"
    address_space = ["172.20.0.0/16"]
    subnets = [
      {
        name    = "GatewaySubnet"
        address = "172.20.1.0/24"
      },
      {
        name    = "VMs"
        address = "172.20.10.0/24"
      }
    ]
  }
]

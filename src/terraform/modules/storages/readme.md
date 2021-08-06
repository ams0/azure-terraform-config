# A module to create multiple storage accounts and containers

Define a storage account and its containers:


```
storages = [
  {
    name        = "uniquename",
    tier        = "Standard",
    type        = "LRS",
    containers  = ["data","runs"],
  }
]
```
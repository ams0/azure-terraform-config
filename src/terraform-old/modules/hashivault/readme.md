# Hashicorp Vault Azure module

Deploy a VM in Azure with Vault and auto-unseal in Azure Keyvault, with MySQL database backend or managed, encrypted disk as storage.

## Auto unseal

Vault will leverage the Managed Identity assigned to the VM to access the Azure Keyvault for the unseal key

## Monitoring

VM runs node-exporter on port 9100. The Network Security Group will expose it only to the virtual network. Also, labels `scrape=true` and `node-exporter=true` will be added (so you can filter using the `azure_sd` service discovery in Prometheus) 
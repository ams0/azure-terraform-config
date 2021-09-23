module "monitoring" {
  source = "./modules/vm"

  count = var.monitoring_vm ? 1 : 0

  rg_name     = "vms"
  rg_location = var.resources_rg_location

  vm_name = "monitoring"

  tags = var.tags
}

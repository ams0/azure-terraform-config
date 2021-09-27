variable "tags" {
  description = "List of tags to be applied to all resources"
}
variable "rg_name" {
  type        = string
  description = "The name of the RG to host resources"
  default     = "aks"
}

variable "default_pool_vm_count" {
  type        = string
  description = "Default pool VM count"
  default     = "2"
}
variable "default_pool_vm_size" {
  type        = string
  description = "Default pool VM Size"
  default     = "Standard_B4ms"
}

variable "network_policy" {
  type        = string
  description = "Network policy"
  default     = "calico"
}

variable "network_plugin" {
  type        = string
  description = "Network plugin"
  default     = "kubenet"
}

variable "dns_prefix" {
  type        = string
  description = "AKS cluster name and DNS prefix"
}

variable "kubernetes_version" {
  type        = string
  description = "Kubernetes version"
}

variable "nodepool_client_id" {
  type        = string
  description = "nodepool_client_id"
}

variable "nodepool_object_id" {
  type        = string
  description = "nodepool_object_id"
}

variable "nodepool_user_assigned_identity_id" {
  type        = string
  description = "nodepool_user_assigned_identity_id"
}

variable "user_assigned_identity_id" {
  type        = string
  description = "user_assigned_identity_id"
}

variable "vnet_subnet_id" {
  type        = string
  description = "vnet_subnet_id"
}

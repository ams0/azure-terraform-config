variable "ssh_port" {
  type        = string
  description = "SSH port"
  default     = "4444"
}

variable "cloud_init_path" {
  description = "Path to cloud-init.tpl file"
  default     = "/../../cloud-init.tpl"
}

variable "admin_user" {
  description = "Admin user name"
  default     = "adminuser"
}

variable "vm_size" {
  description = "VM Size"
  default     = "Standard_B4ms"
}
variable "tags" {
  description = "List of tags to be applied to all resources"
}
variable "rg_name" {
  type        = string
  description = "The name of the RG to host resources"
}

variable "vm_name" {
  type        = string
  description = "The name of the VM to be created"
}

variable "rg_location" {
  type        = string
  description = "The location of the RG to host resources"
}

variable "dns_zone" {
  type        = string
  description = "DNS Zone for VM Public IP"
  default     = "alessandrovozza.com"
}

variable "dns_rg" {
  type        = string
  description = "DNS Zone RG"
  default     = "dns"
}

variable "pubkeylocation" {
  type        = string
  description = "SSH Public key"
  default     = "./files/id_rsa.pub"
}


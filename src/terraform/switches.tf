variable "vpngw" {
  type        = bool
  description = "Deploy a VPN Gateway"
  default     = false
}
variable "storage" {
  type        = bool
  description = "Deploy a Storage Account"
  default     = false
}
variable "workspace" {
  type        = bool
  description = "Deploy a Log Analytics Workspace"
  default     = false
}

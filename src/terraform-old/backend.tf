terraform {
  backend "remote" {
    hostname     = "app.terraform.io"
    organization = "ams0"
    workspaces {
      name = "azure-terraform-config"
    }
  }
}

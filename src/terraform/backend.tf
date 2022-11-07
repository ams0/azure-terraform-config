terraform {
  backend "remote" {
    hostname     = "app.terraform.io"
    organization = "lovelace"
    workspaces {
      name = "azure-terraform-config"
    }
  }
}

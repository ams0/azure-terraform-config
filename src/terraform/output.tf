output "vpngwip" {
  value = azurerm_public_ip.vnetgwip.ip_address
}

output "sharedsecret" {
  value = random_string.sharedsecret.result
}
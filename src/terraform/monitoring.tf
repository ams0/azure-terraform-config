variable "ssh_port" {
  type        = string
  description = "SSH port"
  default     = "4444"
}
resource "azurerm_resource_group" "monitoring" {
  name     = "monitoring"
  location = var.main_rg_location

  tags = var.tags
}

data "azurerm_subnet" "vms" {
  name                 = "vms"
  virtual_network_name = "k8svnet"
  resource_group_name  = azurerm_resource_group.resources.name

}

resource "azurerm_network_interface" "monitoring" {
  name                = "monitoring-nic"
  location            = var.main_rg_location
  resource_group_name = azurerm_resource_group.monitoring.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = data.azurerm_subnet.vms.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.monitoring.id
  }

  tags = var.tags

}

resource "azurerm_network_security_group" "ssh" {
  name                = "sssh"
  location            = var.main_rg_location
  resource_group_name = azurerm_resource_group.monitoring.name

  security_rule {
    name                       = "SSH_allow"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = var.ssh_port
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "SSH_deny"
    priority                   = 101
    direction                  = "Inbound"
    access                     = "Deny"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = var.tags

}

resource "azurerm_network_interface_security_group_association" "sshmonitoring" {
  network_interface_id      = azurerm_network_interface.monitoring.id
  network_security_group_id = azurerm_network_security_group.ssh.id
}


resource "azurerm_public_ip" "monitoring" {
  name                = "monitoring"
  location            = var.main_rg_location
  resource_group_name = azurerm_resource_group.monitoring.name
  allocation_method   = "Static"

  tags = var.tags

}

data "azurerm_dns_zone" "monitoring" {
  name                = "alessandrovozza.com"
  resource_group_name = "dns"
}

resource "azurerm_dns_a_record" "monitoring" {
  name                = "monitoring"
  zone_name           = data.azurerm_dns_zone.monitoring.name
  resource_group_name = data.azurerm_resource_group.dns.name
  ttl                 = 30
  records             = [azurerm_public_ip.monitoring.ip_address]
}

data "template_file" "cloudconfig" {
  template = file("${path.module}/cloud-init.tpl")

  vars = {
    ssh_port    = var.ssh_port
    docker_user = "adminuser"
    #    timezone = var.timezone
    #    password = data.azurerm_key_vault_secret.vaultsecret.value
    #    tpot_flavor = var.tpot_flavor
    #    web_user = var.web_user
    #    web_password = var.web_password
  }
}

data "template_cloudinit_config" "config" {
  gzip          = true
  base64_encode = true

  part {
    content_type = "text/cloud-config"
    content      = data.template_file.cloudconfig.rendered
  }
}

resource "azurerm_linux_virtual_machine" "monitoring" {
  name                = "monitoring"
  location            = var.main_rg_location
  resource_group_name = azurerm_resource_group.monitoring.name
  size                = "Standard_B4ms"
  admin_username      = "adminuser"
  network_interface_ids = [
    azurerm_network_interface.monitoring.id,
  ]

  admin_ssh_key {
    username   = "adminuser"
    public_key = file("./files/id_rsa.pub")
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-focal"
    sku       = "20_04-lts"
    version   = "20.04.202109080"
  }

  custom_data = data.template_cloudinit_config.config.rendered

  tags = var.tags

}

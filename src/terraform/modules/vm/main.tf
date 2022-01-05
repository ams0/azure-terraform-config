

data "azurerm_resource_group" "vms" {
  name = var.rg_name
}

data "azurerm_resource_group" "resources" {
  name = "resources"
}

data "azurerm_subnet" "vms" {
  name                 = "vms"
  virtual_network_name = "k8svnet"
  resource_group_name  = data.azurerm_resource_group.resources.name

}

resource "azurerm_public_ip" "pubip" {
  name                = "${var.vm_name}-pubip"
  location            = var.rg_location
  resource_group_name = data.azurerm_resource_group.vms.name
  allocation_method   = "Static"

  tags = var.tags

}

resource "azurerm_network_interface" "nic" {
  name                = "${var.vm_name}-nic"
  location            = var.rg_location
  resource_group_name = data.azurerm_resource_group.vms.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = data.azurerm_subnet.vms.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.pubip.id
  }

  tags = var.tags

}

resource "azurerm_network_security_group" "ssh" {
  name                = "${var.vm_name}-ssh"
  location            = var.rg_location
  resource_group_name = data.azurerm_resource_group.vms.name

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
  network_interface_id      = azurerm_network_interface.nic.id
  network_security_group_id = azurerm_network_security_group.ssh.id
}




resource "azurerm_dns_a_record" "dnsrecord" {
  name                = "monitoring"
  zone_name           = var.dns_zone
  resource_group_name = var.dns_rg
  ttl                 = 30
  records             = [azurerm_public_ip.pubip.ip_address]
}

data "template_file" "cloudconfig" {
  template = file("${path.module}${var.cloud_init_path}")

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

resource "azurerm_linux_virtual_machine" "vm" {
  name                = var.vm_name
  location            = var.rg_location
  resource_group_name = data.azurerm_resource_group.vms.name
  size                = var.vm_size
  admin_username      = var.admin_user
  network_interface_ids = [
    azurerm_network_interface.nic.id,
  ]

  identity {
    type = "SystemAssigned"
  }
  admin_ssh_key {
    username   = var.admin_user
    public_key = file("${var.pubkeylocation}")
  }

  os_disk {
    name                 = "${var.vm_name}-osdisk"
    caching              = "ReadWrite"
    storage_account_type = "StandardSSD_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-focal"
    sku       = "20_04-lts"
    version   = "20.04.202201040"
  }

  custom_data = data.template_cloudinit_config.config.rendered

  tags = var.tags

}

resource "azurerm_virtual_machine_extension" "aadlinux" {
  name                       = "AADLoginForLinux"
  virtual_machine_id         = azurerm_linux_virtual_machine.vm.id
  publisher                  = "Microsoft.Azure.ActiveDirectory.LinuxSSH"
  type                       = "AADLoginForLinux"
  type_handler_version       = "1.0"
  auto_upgrade_minor_version = true
}

# az ssh vm -n monitoring -g vms --port 4444 (if you are part of the sshlinux AAD group)
resource "azurerm_role_assignment" "vmadmin" {
  scope                = azurerm_linux_virtual_machine.vm.id
  role_definition_name = "Virtual Machine Administrator Login"
  principal_id         = "b46e5608-feca-4afc-8c46-832d5bbe6748"  #sshlinux AAD group in 12c.. tenant
}

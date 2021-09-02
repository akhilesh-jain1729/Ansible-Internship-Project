variable "subscription_id" {}
variable "tenant_id"  {}
variable "client_id" {}
variable "client_secret" {}
variable "azure_region" {}
variable "azure_vm_username" {}
variable "azure_vm_admin_password" {}

provider "azurerm" {
  subscription_id = var.subscription_id
  tenant_id       = var.tenant_id
  client_id       = var.client_id
  client_secret   = var.client_secret

  features {
  virtual_machine {
      delete_os_disk_on_deletion = true
    }
  }
}

resource "azurerm_resource_group" "myrg" {
  name     = "mnkc_rg"
  location = var.azure_region
}


resource "tls_private_key" "keypair" {
  algorithm   = "RSA"
}
resource "local_file" "privatekey" {
    content   = tls_private_key.keypair.private_key_pem
    filename  = "k8s-cluster-vm-key.pem"
}

output "key" {
  value = tls_private_key.keypair.public_key_openssh
}

resource "azurerm_ssh_public_key" "example" {
  name                = "k8s-cluster-vm-key"
  resource_group_name = azurerm_resource_group.myrg.name
  location            = var.azure_region
  public_key          = tls_private_key.keypair.public_key_openssh
}

resource "azurerm_network_security_group" "vm_sg" {
  name                = "security_wizard"
  resource_group_name = azurerm_resource_group.myrg.name
  location            = azurerm_resource_group.myrg.location
  security_rule = []
  tags = {
    Name = "security_wizard"
  }
}

resource "azurerm_network_security_rule" "sgrule1" {
    name                       = "allow-ssh"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "22"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
    resource_group_name = azurerm_resource_group.myrg.name
    network_security_group_name = azurerm_network_security_group.vm_sg.name
}

resource "azurerm_network_security_rule" "sgrule2" {
    name                       = "allow-http"
    priority                   = 101
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "80"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
    resource_group_name = azurerm_resource_group.myrg.name
    network_security_group_name = azurerm_network_security_group.vm_sg.name
}

resource "azurerm_network_security_rule" "sgrule3" {
    name                       = "k8s-1"
    priority                   = 102
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "6443"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
    resource_group_name = azurerm_resource_group.myrg.name
    network_security_group_name = azurerm_network_security_group.vm_sg.name
}

resource "azurerm_network_security_rule" "sgrule4" {
    name                       = "k8s-2"
    priority                   = 103
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "8080"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
    resource_group_name = azurerm_resource_group.myrg.name
    network_security_group_name = azurerm_network_security_group.vm_sg.name
}

resource "azurerm_network_security_rule" "sgrule5" {
    name                       = "ping"
    priority                   = 104
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Icmp"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
    resource_group_name = azurerm_resource_group.myrg.name
    network_security_group_name = azurerm_network_security_group.vm_sg.name
}

resource "azurerm_network_security_rule" "sgrule6" {
    name                       = "egress"
    priority                   = 100
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
    resource_group_name = azurerm_resource_group.myrg.name
    network_security_group_name = azurerm_network_security_group.vm_sg.name
}

resource "azurerm_virtual_network" "vpc" {
  name                = "vpc"
  resource_group_name = azurerm_resource_group.myrg.name
  location            = azurerm_resource_group.myrg.location
  address_space       = ["10.0.0.0/16"]
  subnet              = []
  tags =  {
      Name = "vpc_mnkc"
  }
}

resource "azurerm_subnet" "vm_subnet" {
  name                 = "subnet1"
  resource_group_name  = azurerm_resource_group.myrg.name
  virtual_network_name = azurerm_virtual_network.vpc.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_public_ip" "vm_pubip" {
  name                = "acceptanceTestPublicIp1"
  resource_group_name = azurerm_resource_group.myrg.name
  location            = azurerm_resource_group.myrg.location
  allocation_method   = "Dynamic"

  tags = {
    Name = "slavevm-ip"
  }
}

resource "azurerm_network_interface" "vm_nic" {
  name                = "slave1-nic"
  resource_group_name = azurerm_resource_group.myrg.name
  location            = azurerm_resource_group.myrg.location
  enable_ip_forwarding = true

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.vm_subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.vm_pubip.id
  }
}

resource "azurerm_linux_virtual_machine" "azure_slave_vm" {
  name                = "azure_slave2"
  resource_group_name = azurerm_resource_group.myrg.name
  location            = azurerm_resource_group.myrg.location
  size                = "Standard_F2"
  disable_password_authentication = false
  admin_username      = var.azure_vm_username
  admin_password      = var.azure_vm_admin_password
  computer_name       = "azure-slave"  
  
  network_interface_ids = [
    azurerm_network_interface.vm_nic.id,
  ]

  admin_ssh_key {
    username   = var.azure_vm_username
    public_key = tls_private_key.keypair.public_key_openssh
  }

  os_disk {
    name                 = "vm_disk"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
    disk_size_gb         = 40
  }

  source_image_reference {
    publisher = "OpenLogic"
    offer     = "Centos"
    sku       = "7.5"
    version   = "latest"
  }

  tags = {
    Name = "k8s-slave-azure"
  }
}

 output "azure_ip_data" {
    value = "[azure]\n${azurerm_linux_virtual_machine.azure_slave_vm.public_ip_address} ansible_user=${var.azure_vm_username}"
}
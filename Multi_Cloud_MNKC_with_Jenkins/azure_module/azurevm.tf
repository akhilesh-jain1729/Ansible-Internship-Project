variable "public_key" {}

resource "azurerm_resource_group" "myrg" {
  name     = "mnkc_rg"
  location = var.azure_region
}

output "azure_rg_name" {
  value = azurerm_resource_group.myrg.name
}



resource "azurerm_ssh_public_key" "cluster-key" {
  name                = "k8s-cluster-vm-key"
  resource_group_name = azurerm_resource_group.myrg.name
  location            = var.azure_region
  public_key          = var.public_key
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

# # Connect the security group to the network interface
# resource "azurerm_network_interface_security_group_association" "nic_sg" {
#     network_interface_id      = azurerm_network_interface.vm_nic.id
#     network_security_group_id = azurerm_network_security_group.vm_sg.id
# }

resource "azurerm_linux_virtual_machine" "azure_slave_vm" {
  name                = "azure_slave2"
  resource_group_name = azurerm_resource_group.myrg.name
  location            = azurerm_resource_group.myrg.location
  size                = "Standard_F2"
  #size                = "Standard_B1s"
  disable_password_authentication = false
  admin_username      = var.azure_vm_username
  admin_password      = var.azure_vm_admin_password
  computer_name       = "azure-slave"  
  
  network_interface_ids = [
    azurerm_network_interface.vm_nic.id,
  ]

  admin_ssh_key {
    username   = var.azure_vm_username
    public_key = var.public_key
  }

  os_disk {
    name                 = "vm_disk"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
    disk_size_gb         = 70
  }

  source_image_reference {
    publisher = "OpenLogic"
    offer     = "Centos"
    sku       = "7.5"
    version   = "latest"
  }

    # source_image_reference {
    #     publisher = "RedHat"
    #     offer     = "RHEL"
    #     sku       = "82gen2"
    #     version   = "latest"
    # }


  tags = {
    Name = "k8s-slave-azure"
  }
}

output "azure_slave_ip" {
  value = "${azurerm_linux_virtual_machine.azure_slave_vm.public_ip_address}"
}

output "azure_vm_username" {
  value = "${var.azure_vm_username}"
}
resource "azurerm_virtual_network" "vpc" {
  name                = "vpc"
  resource_group_name = azurerm_resource_group.myrg.name
  location            = azurerm_resource_group.myrg.location
  address_space       = ["${var.azure_vpc_range}"]
  #subnet              = []
  tags =  {
      Name = "vpc_mnkc"
  }
}

resource "azurerm_subnet" "vm_subnet" {
  name                 = "subnet1"
  resource_group_name  = azurerm_resource_group.myrg.name
  virtual_network_name = azurerm_virtual_network.vpc.name
  address_prefixes     = ["${var.azure_subnet1_range}"]
}

resource "azurerm_public_ip" "azure_pubip1" {
  name                = "publicIPforVPN"
  resource_group_name = azurerm_resource_group.myrg.name
  location            = azurerm_resource_group.myrg.location
  allocation_method   = "Static"
  ip_version          = "IPv4"
}
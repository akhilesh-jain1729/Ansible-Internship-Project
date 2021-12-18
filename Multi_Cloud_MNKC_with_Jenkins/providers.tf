provider "aws" {
  region                 = "ap-south-1"
  alias                  = "myaws"
  access_key             = var.aws_access_key
  secret_key             = var.aws_secret_access_key
  skip_region_validation = true
}

provider "azurerm" {
  features {}
}

provider "azurerm" {
  subscription_id = var.subscription_id
  tenant_id       = var.tenant_id
  client_id       = var.client_id
  client_secret   = var.client_secret
  alias = "myazure"
  features {
      virtual_machine {
      delete_os_disk_on_deletion = true
      }
  }
}
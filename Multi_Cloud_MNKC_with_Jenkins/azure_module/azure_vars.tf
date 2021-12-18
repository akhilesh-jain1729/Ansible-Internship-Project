
variable "azure_region" {
  type = string
  default = "Central India"
  description = "Location for Azure Deployments"
}

variable "azure_vm_username" {
  type = string
  default = "akhil"
  description = "Admin username"
}

variable "azure_vm_admin_password" {
  type = string
  default = "Akhil29@"
  description = "Password for admin username"
}

variable "azure_vpc_range" {
  default = "192.168.0.0/16"
  description = "IP Range for VPC"
}

variable "azure_subnet1_range" {
  default = "192.168.1.0/24"
  description = "IP Range for Subnet1"
}
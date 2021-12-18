variable "aws_master_ip" {}
variable "aws_slave_ip" {}
variable "azure_slave_ip" {}
variable "aws_vm1_username" {}
variable "aws_vm2_username" {}
variable "azure_vm_username" {}

variable "azure_vm_admin_password" {}
locals {
inventory = "[aws_master]\n${var.aws_master_ip} ansible_user=${var.aws_vm1_username}\n\n[aws_slave1]\n${var.aws_slave_ip} ansible_user=${var.aws_vm2_username}\n\n[azure_slave1]\n${var.azure_slave_ip} ansible_user=${var.azure_vm_username} ansible_become_password=${var.azure_vm_admin_password}\n\n[slaves:children]\naws_slave1\nazure_slave1\n"
}

resource "local_file" "ipfile" {
    content = "${local.inventory}"
    filename = "ip.txt"
}

output "inventory" {
  value = local.inventory
}
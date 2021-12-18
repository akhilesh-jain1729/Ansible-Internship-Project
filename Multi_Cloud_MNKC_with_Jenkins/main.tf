module "cluster_key"{
  source = "./local_module"
  key_name = var.key_name
}

module "aws" {
  depends_on = [
    module.cluster_key
  ]
  source = "./aws_module"
  providers = {
        aws = aws.myaws
  }
    aws_instance_user       = var.aws_instance_user
    public_key              = module.cluster_key.key
    key_name                = var.key_name
}

module "azure" {
  depends_on = [
    module.cluster_key
  ]
  source = "./azure_module" 
  providers = {
    azurerm = azurerm.myazure
  }   
    public_key              = module.cluster_key.key 
}

module "ansible_inventory" {
  source            = "./ansible_inventory_module"
  aws_master_ip     = module.aws.aws_master_ip
  aws_slave_ip      = module.aws.aws_slave_ip
  azure_slave_ip    = module.azure.azure_slave_ip
  aws_vm1_username  = module.aws.aws_vm1_username
  aws_vm2_username  = module.aws.aws_vm2_username
  azure_vm_username = var.azure_vm_username
  azure_vm_admin_password = var.azure_vm_admin_password
}

module "git" {
  source          = "./github_module"
  repo_url        = var.repo_url
  repo_name       = var.repo_name
  inventory       = module.ansible_inventory.inventory
  token           = var.token
  private_key     = module.cluster_key.privatekey
}

resource "null_resource" "createppk" {
    depends_on = [
    module.cluster_key
  ]
  provisioner "local-exec" {
	    command = "winscp.com /keygen k8s-cluster-vm-key.pem /output=k8s-cluster-vm-key.ppk"
  }
}
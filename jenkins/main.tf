provider "github" {
  token = var.token
}

module "ec2" {
     source = "./ec2"
     aws_access_key        = var.aws_access_key
     aws_secret_access_key = var.aws_secret_access_key
     public_key                   = module.azure.key
}

module "azure" {
    source = "./azure" 
    subscription_id         = var.subscription_id
    tenant_id               = var.tenant_id
    client_id               = var.client_id
    client_secret           = var.client_secret  
    azure_region            = var.azure_region
    azure_vm_username       = var.azure_vm_username
    azure_vm_admin_password = var.azure_vm_admin_password    
}

 resource "local_file" "ipfile" {
    depends_on = [
          module.ec2, module.azure
   ]
    content = "${module.ec2.ip_data}\n${module.azure.azure_ip_data}"
    filename = "ip.txt"
 }

module "git" {
  depends_on = [
          module.ec2, module.azure
  ]
    source = "./github"
    repo_url = var.repo_url
    repo_name = var.repo_name
    ipdata = module.ec2.ip_data
    azure_ip_data = module.azure.azure_ip_data
    token=var.token
}

resource "null_resource" "createppk" {
  depends_on = [
    module.ec2, module.azure, module.git
  ]
  provisioner "local-exec" {
	    command = "winscp.com /keygen k8s-cluster-vm-key.pem /output=k8s-cluster-vm-key.ppk"
  }
}

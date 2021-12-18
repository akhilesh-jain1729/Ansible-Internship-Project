variable "token" {
  type = string
  default = "your_token"
  description = "Token for authentication"
}

variable "aws_access_key" {
  type = string
  default = "AKIAUZEYQZ7AGOIQ3WTJ"
  description = "Access key in AWS"
}

variable "aws_secret_access_key" {
  type = string
  default = "uWgg3th4sxjpy8COVemHC6i65mIj52bYGGIfi33H"
  description = "Secret Access key in AWS"
}

variable "aws_instance_user" {
  type = string
  default = "centos"
  description = "user name of Centos instance"
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

variable "key_name" {
  type = string
  default = "k8s-cluster-vm-key"
  description = "Name of key for the Cluster"
}

variable "subscription_id" {
  type = string
  default  = "6c8c8a7b-6023-4b39-8f24-f8aa195e268b"
  description = "Subscription ID in my Azure"
}

  
variable "tenant_id"  {
  type = string
  default  = "ade53179-a4d7-4e27-ab4b-f418b77cd9ca"
  description = "Tenant ID/Directory ID in my Azure"
  }  

variable "client_id" {
  type = string
  default   = "0a3e05a9-ef20-4842-99f9-005709eac1f6"
  description = "Client ID in my Azure"
}
      
variable "client_secret" {
  type = string
  default = "m16Bdvi1_X.Eeru~f2yFg~gh9DWa-BwG9a"
  description = "Client Secret in my Azure"
}


variable "repo_name" {
  type = string
  default = "Ansible-Internship-Project"
  description = "Repository Name of Github"
}

variable "repo_url" {
  type = string
  default = "https://<user>:<pass>@github.com/akhilesh-jain1729/Ansible-Internship-Project.git"
  description = "Repository Url"
}

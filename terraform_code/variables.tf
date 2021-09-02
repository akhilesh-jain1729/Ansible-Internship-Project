variable "token" {
  type = string
  default = "<your Pat>"
  description = "Token for authentication"
}

variable "aws_access_key" {
  type = string
  default = "your ak"
  description = "Access key in AWS"
}

variable "aws_secret_access_key" {
  type = string
  default = "your sak"
  description = "Secret Access key in AWS"
}

variable "subscription_id" {
  type = string
  default  = "enter subs id"
  description = "Subscription ID in my Azure"
}

  
variable "tenant_id"  {
  type = string
  default  = "ade53179-a4d7-4e27-ab4b-f418b77cd9ca"
  description = "Tenant ID/Directory ID in my Azure"
  }  

variable "client_id" {
  type = string
  default   = "enter tenant id"
  description = "Client ID in my Azure"
}
      
variable "client_secret" {
  type = string
  default = "enter client secret"
  description = "Client Secret in my Azure"
}

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

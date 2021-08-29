variable "repo_name" {}
#variable "repo_url" {}
variable "token" {}
variable "ipdata" {}


# resource "null_resource" "nulllocal1"  {
# 	provisioner "local-exec" {
# 	    command = "git remote add origin ${var.repo_url}"
#   	}
# }

# resource "null_resource" "nulllocal1b"  {
# 	provisioner "local-exec" {
# 	    command = "git remote set-url origin ${var.repo_url}"
#   	}
# }



# resource "null_resource" "nulllocal2"  {
# 	provisioner "local-exec" {
# 	    command = "git remote -v"
#   	}
# }

# resource "null_resource" "nulllocal3"  {
# 	provisioner "local-exec" {
# 	    command = "gh auth login --with-token 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"
#   	}
# }


# resource "null_resource" "nulllocal4"  {
# 	provisioner "local-exec" {
# 	    command = "git config --global user.email 'akhileshjain9221@gmail.com'"
#   	}
# }

# resource "null_resource" "nulllocal5"  {
# 	provisioner "local-exec" {
# 	    command = "git config --global user.name 'Akhilesh Jain'"
#   	}
# }

# resource "null_resource" "nulllocal6"  {
# 	provisioner "local-exec" {
# 	    command = "git add ip.txt"
#   	}
# }

# resource "null_resource" "nulllocal7"  {
# 	provisioner "local-exec" {
# 	    command = "git commit -m 'First Commit'"
#   	}
# }

# resource "null_resource" "nulllocal8"  {
# 	provisioner "local-exec" {
# 	    command = "git push origin master"
#   	}
# }

#Uploading Content to Github
resource "github_repository_file" "file" {
  repository          = var.repo_name
  branch              = "main"
  file                = "ip.txt"
  content             = var.ipdata
  commit_message      = "Ansible Inventory file updated"
  commit_author       = "Akhilesh Jain"
  commit_email        = "akhileshjain9221@gmail.com"
  overwrite_on_create = true
}

variable "key_name" {}
resource "tls_private_key" "keypair" {
  algorithm   = "RSA"
  rsa_bits  = 4096
}

resource "local_file" "privatekey" {
    content   = tls_private_key.keypair.private_key_pem
    file_permission = "400"
    filename  = "${var.key_name}.pem"
}

output "key" {
  value = tls_private_key.keypair.public_key_openssh
}

output "privatekey" {
  value = tls_private_key.keypair.private_key_pem
}
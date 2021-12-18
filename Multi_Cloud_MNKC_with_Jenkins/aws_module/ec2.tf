variable "key_name" {}
variable "public_key" {}
variable "aws_instance_user" {}


resource "aws_key_pair" "deployer" {
  key_name   = var.key_name
  public_key = var.public_key
}

resource "aws_security_group" "secure" {
  name        = "secure"
  description = "Allow HTTP, SSH inbound traffic"
  vpc_id      = aws_vpc.myvpc.id

  ingress {
    description = "http"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "ssh"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
   ingress {
    description = "ping"
    from_port   = 0
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "all"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks = ["0.0.0.0/0"]
}

  tags = {
    Name = "security-wizard"
  }
}

resource "aws_instance" "k8s-master" {
  #centos_instance ami
  ami             = "ami-026f33d38b6410e30"
  instance_type   = "t2.medium"
  key_name        = var.key_name
  subnet_id       = aws_subnet.mysubnet1.id
  vpc_security_group_ids = [ aws_security_group.secure.id ]

  root_block_device  {
    volume_type           = "gp2"
    volume_size           = "20"  
    delete_on_termination = true
  }


  tags = {
    Name = "k8s-Master"
  }
}

resource "aws_instance" "k8s-slave" {

  ami             = "ami-026f33d38b6410e30"
  instance_type   = "t2.micro"
  key_name        = var.key_name
  #count = 1
  subnet_id       = aws_subnet.mysubnet1.id
  vpc_security_group_ids = [ aws_security_group.secure.id ]

  root_block_device  {
    volume_type           = "gp2"
    volume_size           =  "8"  
    delete_on_termination = true
  }

  tags = {
    Name = "k8s-Slave1-aws"
  }
}

output "aws_master_ip" {
  value = "${aws_instance.k8s-master.public_ip}"
}

output "aws_slave_ip" {
  value = "${aws_instance.k8s-slave.public_ip}"
}

output "aws_vm1_username" {
  value = "${var.aws_instance_user}"
}

output "aws_vm2_username" {
  value = "${var.aws_instance_user}"
}




# resource "aws_network_interface" "master_nic" {
#   subnet_id      = aws_subnet.mysubnet1.id
#   attachment {
#     instance     = aws_instance.k8s-master.id
#     device_index = 0
#   }
#   tags = {
#     Name = "Master NIC"
#   }
# }

# resource "aws_network_interface" "slave_nic" {
#   subnet_id      = aws_subnet.mysubnet1.id
#   attachment {
#     instance     = aws_instance.k8s-slave.id
#     device_index = 0
#   }
#   tags = {
#     Name = "Slave NIC"
#   }
# }
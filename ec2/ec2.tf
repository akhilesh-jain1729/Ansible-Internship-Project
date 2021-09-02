variable "aws_access_key" {}
variable "aws_secret_access_key" {}
variable "public_key" {}

provider "aws" {
  access_key = var.aws_access_key
  secret_key = var.aws_secret_access_key
  region     = "ap-south-1"
}

resource "aws_vpc" "myvpc" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"
  tags = {
    Name = "aws_vpc_mnkc_project"
  }
}

resource "aws_subnet" "mysubnet1" {
  vpc_id     = aws_vpc.myvpc.id
  cidr_block = "10.0.2.0/24"
  availability_zone = "ap-south-1b"
  map_public_ip_on_launch = true
  tags = {
    Name = "subnet1_mnkc_project"
  }
}


resource "aws_key_pair" "deployer" {
  key_name   = "k8s-cluster-vm-key"
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


resource "aws_instance" "k8s-master" {
  ami             = "ami-0bcf5425cdc1d8a85"
  instance_type   = "t2.micro"
  key_name        = "jenkins-master-key"
  subnet_id = aws_subnet.mysubnet1.id
  vpc_security_group_ids = [ aws_security_group.secure.id ]

  tags = {
    Name = "k8s-Master"
  }
}

resource "aws_instance" "k8s-slave" {
  ami             = "ami-0bcf5425cdc1d8a85"
  instance_type   = "t2.micro"
  key_name        = "jenkins-master-key"
  #count = 1
  subnet_id = aws_subnet.mysubnet1.id
  vpc_security_group_ids = [ aws_security_group.secure.id ]
  
  tags = {
    Name = "k8s-Slave1-aws"
  }
}

 output "ip_data" {
    value = "[aws] \n${aws_instance.k8s-master.public_ip} ansible_user=ec2-user  \n\n[aws1] \n${aws_instance.k8s-slave.public_ip} ansible_user=ec2-user \n"
}
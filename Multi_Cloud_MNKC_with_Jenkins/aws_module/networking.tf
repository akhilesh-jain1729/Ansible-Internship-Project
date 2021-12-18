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

resource "aws_internet_gateway" "myigw" {
  vpc_id = aws_vpc.myvpc.id

  tags = {
    Name = "K8s-igw"
  }
}

resource "aws_route_table" "rtable" {
  vpc_id = aws_vpc.myvpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.myigw.id
  }

  tags = {
    Name = "Custom-route-table"
  }
}

resource "aws_route_table_association" "rt_association" {
  depends_on = [ aws_route_table.rtable ]
  subnet_id      = aws_subnet.mysubnet1.id
  route_table_id = aws_route_table.rtable.id
}


output "aws_vpcid" {
  value = aws_vpc.myvpc.id
}

output "aws_subnet1id" {
  value = aws_subnet.mysubnet1.id
}
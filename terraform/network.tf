resource "aws_vpc" "VPC" {
  cidr_block           = var.vpc_cidr
  instance_tenancy     = "default"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    "Name" : "terraform vpc"
  }
}

resource "aws_internet_gateway" "IGW" {
  vpc_id = aws_vpc.VPC.id
}

resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.VPC.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.IGW.id
  }
}

resource "aws_subnet" "subnetA" {
  vpc_id                  = aws_vpc.VPC.id
  cidr_block              = var.subnetA_cidr
  map_public_ip_on_launch = true

  tags = {
    "Name" : "SubnetA"
  }
}

resource "aws_route_table_association" "subnetA_association" {
  subnet_id      = aws_subnet.subnetA.id
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_subnet" "subnetB" {
  vpc_id                  = aws_vpc.VPC.id
  cidr_block              = var.subnetB_cidr
  map_public_ip_on_launch = true

  tags = {
    "Name" : "SubnetB"
  }
}

resource "aws_route_table_association" "subnetB_association" {
  subnet_id      = aws_subnet.subnetB.id
  route_table_id = aws_route_table.public_route_table.id
}

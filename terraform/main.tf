
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }

    local = {
      source  = "hashicorp/local"
      version = "~> 2.1.0"
    }

    tls = {
      source  = "hashicorp/tls"
      version = "~> 3.1.0"
    }
  }
  required_version = ">= 0.14.9"
}

provider "aws" {
  profile = var.profile
  region  = var.region

  default_tags {
    tags = {
      "Environment" = "D1"
      "project" : "terraform"
    }
  }
}

resource "aws_resourcegroups_group" "terraform_goup" {
  name = "terraform_group"

  resource_query {
    query = <<JSON
{
  "ResourceTypeFilters": [
    "AWS::AllSupported"
  ],
  "TagFilters": [
    {
      "Key": "project",
      "Values": ["terraform"]
    },
    {
      "Key": "Environment",
      "Values": ["D1"]
    }
  ]
}
JSON
  }
}

resource "tls_private_key" "generated_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "aws_key" {
  key_name   = var.aws_key_pair_name
  public_key = tls_private_key.generated_key.public_key_openssh
}

resource "local_file" "private_key" {
  filename             = pathexpand("./${var.aws_key_pair_name}.pem")
  file_permission      = "600"
  directory_permission = "700"
  sensitive_content    = tls_private_key.generated_key.private_key_pem
}

resource "local_file" "public_key" {
  filename             = pathexpand("./${var.aws_key_pair_name}.pub")
  file_permission      = "600"
  directory_permission = "700"
  sensitive_content    = tls_private_key.generated_key.private_key_pem
}

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

resource "aws_security_group" "web_security_group" {
  name   = "web_security_group"
  vpc_id = aws_vpc.VPC.id

}

resource "aws_security_group_rule" "egress_all" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.web_security_group.id
}

resource "aws_security_group_rule" "ingress_ssh" {
  type              = "ingress"
  from_port         = 0
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.web_security_group.id
}

resource "aws_security_group_rule" "ingress_http" {
  type              = "ingress"
  from_port         = 0
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.web_security_group.id
}

resource "aws_instance" "instanceA" {
  ami             = var.ami
  instance_type   = "t2.micro"
  subnet_id       = aws_subnet.subnetA.id
  key_name        = var.aws_key_pair_name
  security_groups = [aws_security_group.web_security_group.id]

  lifecycle {
    ignore_changes = [ami]
  }

  user_data = file("${path.module}/startup.sh")

  tags = {
    "Name" : "InstanceA"
  }
}

resource "aws_instance" "instanceB" {
  ami             = var.ami
  instance_type   = "t2.micro"
  subnet_id       = aws_subnet.subnetB.id
  key_name        = var.aws_key_pair_name
  security_groups = ["${aws_security_group.web_security_group.id}"]

  lifecycle {
    ignore_changes = [ami]
  }

  tags = {
    "Name" : "InstanceB"
  }
}

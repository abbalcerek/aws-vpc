variable "aws_key_pair_name" {
  type    = string
  default = "terraform_key_par"
}

variable "profile" {
  type    = string
  default = "priv"
}

variable "region" {
  type    = string
  default = "us-east-2"
}

variable "vpc_cidr" {
  type    = string
  default = "192.168.0.0/20"
}

variable "subnetA_cidr" {
  type    = string
  default = "192.168.2.0/24"
}

variable "subnetB_cidr" {
  type    = string
  default = "192.168.1.0/24"
}

variable "ami" {
  type    = string
  default = "ami-03a0c45ebc70f98ea"
}


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

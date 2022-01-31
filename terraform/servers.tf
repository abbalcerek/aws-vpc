
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

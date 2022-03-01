locals {
  ec2_ami = var.region == "sgp" ? var.ubuntu-ami-sgp : var.ubuntu-ami-us
}

resource "aws_instance" "nginx" {
  ami                         = local.ec2_ami
  instance_type               = var.ec2_instance_type
  private_ip                  = var.nginx
  subnet_id                   = aws_subnet.subnet.id
  vpc_security_group_ids      = [aws_security_group.nginx.id]
  availability_zone           = var.availability_zone_1
  key_name                    = var.ec2_key_name
  associate_public_ip_address = true

  tags = {
    Name = "nginx"
  }
}

# data "aws_ami" "amazon_linux_2" {
#   most_recent = true
#   name_regex  = "^amzn2-ami-.+-hvm-.+-x86_64"

#   filter {
#     name   = "name"
#     values = ["amzn2-ami-*"]
#   }

#   filter {
#     name   = "virtualization-type"
#     values = ["hvm"]
#   }

#   owners = ["137112412989"] # Amazon
# }

data "aws_ami" "ubuntu" {
  most_recent = true
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

locals {
  ec2_ami = var.ec2_ami != null ? var.ec2_ami : data.aws_ami.ubuntu.id
}

resource "aws_instance" "mongo" {
  count = var.ec2_count

  ami           = local.ec2_ami
  instance_type = var.ec2_instance_type
  //TODO: edit
  disable_api_termination     = false
  key_name                    = var.ec2_key_name
  vpc_security_group_ids      = [aws_security_group.mongo.id]
  user_data_base64            = data.cloudinit_config.mongo.rendered
  subnet_id                   = var.subnet_id
  associate_public_ip_address = true
  iam_instance_profile        = aws_iam_instance_profile.mongo.name

  ebs_block_device {
    //TODO: edit
    delete_on_termination = true
    device_name           = local.mongo_xfs_device
    volume_size           = 20
  }

  tags = {
    Name = "mongo-${count.index}"
  }
}

output "ips" {
  value = [for i in aws_instance.mongo : {
    public  = i.public_ip
    private = i.private_ip
  }]
}

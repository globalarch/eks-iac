resource "aws_subnet" "subnet" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.private_subnet_cidr
  availability_zone = var.availability_zone_1

  tags = {
    Name = "subnet"
  }
}

resource "aws_subnet" "subnet_2" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.private_subnet_cidr_2
  availability_zone = var.availability_zone_2

  tags = {
    Name = "subnet 2"
  }
}

# resource "aws_subnet" "subnet_3" {
#   vpc_id            = aws_vpc.vpc.id
#   cidr_block        = var.private_subnet_cidr
#   availability_zone = var.availability_zone_3

#   tags = {
#     Name = "subnet 3"
#   }
# }
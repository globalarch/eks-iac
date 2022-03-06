resource "aws_vpc" "eks" {
  cidr_block = "11.0.0.0/16"
}
resource "aws_subnet" "eks1" {
  vpc_id            = aws_vpc.eks.id
  cidr_block        = "11.0.1.0/24"
  availability_zone = var.availability_zone_1

  map_public_ip_on_launch = true
  tags = {
    "kubernetes.io/role/elb"                    = "1"
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
  }
}

resource "aws_subnet" "eks2" {
  vpc_id            = aws_vpc.eks.id
  cidr_block        = "11.0.2.0/24"
  availability_zone = var.availability_zone_2

  map_public_ip_on_launch = true
  tags = {
    "kubernetes.io/role/elb"                    = "1"
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.eks.id
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.eks.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }
}

resource "aws_route_table_association" "eks1" {
  subnet_id      = aws_subnet.eks1.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "eks2" {
  subnet_id      = aws_subnet.eks2.id
  route_table_id = aws_route_table.public.id
}
resource "aws_route_table" "route-table" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "route-table"
  }
}

resource "aws_route" "to_internet" {
  route_table_id         = aws_route_table.route-table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.internetgateway.id
}

resource "aws_route_table_association" "public-associate" {
  route_table_id = aws_route_table.route-table.id
  subnet_id      = aws_subnet.subnet.id
}

resource "aws_route_table_association" "public-associate-2" {
  route_table_id = aws_route_table.route-table.id
  subnet_id      = aws_subnet.subnet_2.id
}

resource "aws_route_table_association" "public-associate-3" {
  route_table_id = aws_route_table.route-table.id
  subnet_id      = aws_subnet.subnet_3.id
}
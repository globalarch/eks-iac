resource "aws_route" "to_sgp" {
  route_table_id            = var.route_table_id
  destination_cidr_block    = var.sgp_cidr
  vpc_peering_connection_id = aws_vpc_peering_connection.owner.id
}
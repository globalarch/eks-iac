resource "aws_route" "to_us" {
  route_table_id            = var.route_table_id
  destination_cidr_block    = var.us_cidr
  vpc_peering_connection_id = var.vpc_peering_connection_id
}

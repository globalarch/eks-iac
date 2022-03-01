resource "aws_vpc_peering_connection_accepter" "accepter" {
  vpc_peering_connection_id = var.vpc_peering_connection_id
  auto_accept               = true

  tags = {
    Name = "Accepter"
  }
}

resource "aws_vpc_peering_connection" "owner" {
  vpc_id        = var.us_vpc_id
  peer_vpc_id   = var.sgp_vpc_id
  peer_owner_id = var.account_id
  peer_region   = "ap-southeast-1"
  auto_accept   = false

  tags = {
    Name = "Requester"
  }
}

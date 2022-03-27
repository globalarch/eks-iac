output "vpc" {
  value = aws_vpc.vpc

  depends_on = [
    aws_vpc.vpc
  ]
}

output "route_table_id" {
  value = aws_route_table.route-table.id
}

output "subnet" {
  value = aws_subnet.subnet

  depends_on = [
    aws_subnet.subnet
  ]
}

output "subnet_2" {
  value = aws_subnet.subnet_2

  depends_on = [
    aws_subnet.subnet_2
  ]
}

output "subnet_3" {
  value = aws_subnet.subnet_3

  depends_on = [
    aws_subnet.subnet_3
  ]
}
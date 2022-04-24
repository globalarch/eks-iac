resource "aws_security_group" "mongo" {
  vpc_id = var.vpc_id
  name   = "mongo"

  //TODO: add whitelist debug ip + EKS

  ingress {
    description = "allow private subnets"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.US_vpc, var.SGP_vpc]
  }
  ingress {
    description = "allow debug ip"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.debug_cidr]
  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}

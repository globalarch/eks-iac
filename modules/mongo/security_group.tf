resource "aws_security_group" "mongo" {
  vpc_id = var.vpc_id
  name   = "mongo"

  ingress {
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    from_port        = 27017
    to_port          = 27020
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    from_port        = 8
    to_port          = 0
    protocol         = "icmp"
    cidr_blocks      = [var.vpc_cidr, var.peer_vpc_cidr]
    ipv6_cidr_blocks = []
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port        = 8
    to_port          = 0
    protocol         = "icmp"
    cidr_blocks      = [var.vpc_cidr, var.peer_vpc_cidr]
    ipv6_cidr_blocks = []
  }
}

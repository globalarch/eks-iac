# resource "aws_security_group" "nginx" {
#   vpc_id = aws_vpc.vpc.id
#   name   = "nginx"

#   ingress {
#     from_port        = 22
#     to_port          = 22
#     protocol         = "tcp"
#     cidr_blocks      = ["0.0.0.0/0"]
#     ipv6_cidr_blocks = ["::/0"]
#   }

#   ingress {
#     from_port        = 80
#     to_port          = 80
#     protocol         = "tcp"
#     cidr_blocks      = ["0.0.0.0/0"]
#     ipv6_cidr_blocks = ["::/0"]
#   }

#   ingress {
#     from_port        = 443
#     to_port          = 443
#     protocol         = "tcp"
#     cidr_blocks      = ["0.0.0.0/0"]
#     ipv6_cidr_blocks = ["::/0"]
#   }

#   ingress {
#     from_port        = 8
#     to_port          = 0
#     protocol         = "icmp"
#     cidr_blocks      = [var.vpc_cidr, var.peer_vpc_cidr]
#     ipv6_cidr_blocks = []
#   }

#   egress {
#     from_port        = 0
#     to_port          = 0
#     protocol         = "-1"
#     cidr_blocks      = ["0.0.0.0/0"]
#     ipv6_cidr_blocks = ["::/0"]
#   }

#   egress {
#     from_port        = 8
#     to_port          = 0
#     protocol         = "icmp"
#     cidr_blocks      = [var.vpc_cidr, var.peer_vpc_cidr]
#     ipv6_cidr_blocks = []
#   }
# }

# resource "aws_security_group" "cluster" {
#   name        = "EKS cluster - allow all"
#   description = "Allow all"
#   vpc_id      = var.vpc_id

#   ingress {
#     description      = "allow private subnets"
#     from_port        = 0
#     to_port          = 0
#     protocol         = "-1"
#     cidr_blocks      = [var.US_vpc, var.SGP_vpc]
#   }
#   ingress {
#     description      = "allow debug ip"
#     from_port        = 0
#     to_port          = 0
#     protocol         = "-1"
#     cidr_blocks      = [var.debug_cidr]
#   }


#   egress {
#     description      = "allow all"
#     from_port        = 0
#     to_port          = 0
#     protocol         = "-1"
#     cidr_blocks      = ["0.0.0.0/0"]
#     ipv6_cidr_blocks = ["::/0"]
#   }
# }

# resource "aws_security_group" "node" {
#   name        = "EKS node - allow all"
#   description = "Allow all"
#   vpc_id      = var.vpc_id

#   ingress {
#     description      = "allow private subnets"
#     from_port        = 0
#     to_port          = 0
#     protocol         = "-1"
#     cidr_blocks      = [var.US_vpc, var.SGP_vpc]
#   }
#   ingress {
#     description      = "allow debug ip"
#     from_port        = 0
#     to_port          = 0
#     protocol         = "-1"
#     cidr_blocks      = [var.debug_cidr]
#   }

#   egress {
#     description      = "allow all"
#     from_port        = 0
#     to_port          = 0
#     protocol         = "-1"
#     cidr_blocks      = ["0.0.0.0/0"]
#     ipv6_cidr_blocks = ["::/0"]
#   }
# }
module "eks" {
  source = "terraform-aws-modules/eks/aws"

  cluster_name                    = var.cluster_name
  cluster_version                 = "1.21"
  cluster_endpoint_private_access = true
  cluster_endpoint_public_access  = true


  cluster_addons = {
    coredns = {
      resolve_conflicts = "OVERWRITE"
    }
    kube-proxy = {}
    vpc-cni = {
      resolve_conflicts = "OVERWRITE"
    }
  }

  vpc_id     = var.vpc_id
  subnet_ids = [var.subnet_id, var.subnet_id_2]

  eks_managed_node_groups = {
    default = {
      name                   = "default-node-group"
      create_launch_template = false
      launch_template_name   = ""

      min_size     = 2
      max_size     = 5
      desired_size = 3

      instance_types = ["t3.large"]
      capacity_type  = "ON_DEMAND"

      # cluster_primary_security_group_id = aws_security_group.cluster.id
      create_security_group = true

      security_group_name = "Allow whitelisted and private only"
      security_group_rules = [{
        type        = "ingress"
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = concat([var.US_vpc, var.SGP_vpc], var.debug_cidrs)
        }, {
        type             = "egress"
        from_port        = 0
        to_port          = 0
        protocol         = "-1"
        cidr_blocks      = ["0.0.0.0/0"]
        ipv6_cidr_blocks = ["::/0"]
      }]
    }
  }
}


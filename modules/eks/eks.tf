module "eks" {
  source = "terraform-aws-modules/eks/aws"

  cluster_name                    = var.cluster_name
  cluster_version                 = "1.21"
  cluster_endpoint_private_access = true
  cluster_endpoint_public_access  = true

  create_node_security_group    = false
  create_cluster_security_group = false

  node_security_group_id    = aws_security_group.node.id
  cluster_security_group_id = aws_security_group.cluster.id

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
      desired_size = 4

      instance_types = ["m4.large"]
      capacity_type  = "ON_DEMAND"
    }
  }
}


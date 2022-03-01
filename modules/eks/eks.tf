module "eks" {
  source = "terraform-aws-modules/eks/aws"

  cluster_name                    = "global-arch-tf"
  cluster_version                 = "1.21"
  cluster_endpoint_private_access = true
  cluster_endpoint_public_access  = true

  create_node_security_group = false
  create_cluster_security_group = false

  
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
  subnet_ids = var.subnet_ids # ["subnet-abcde012", "subnet-bcde012a", "subnet-fghi345a"]

  eks_managed_node_groups = {
    default = {
      min_size     = 1
      max_size     = 5
      desired_size = 4

      instance_types = ["t3.large"]
      capacity_type  = "ON_DEMAND"
    }
  }
}


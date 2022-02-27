module "eks" {
  source = "terraform-aws-modules/eks/aws"

  cluster_name                    = "global-arch-tf"
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

  #   cluster_encryption_config = [{
  #     provider_key_arn = "ac01234b-00d9-40f6-ac95-e42345f78b00"
  #     resources        = ["secrets"]
  #   }]

  vpc_id     = var.vpc_id
  subnet_ids = var.subnet_ids # ["subnet-abcde012", "subnet-bcde012a", "subnet-fghi345a"]


  # EKS Managed Node Group(s)
  eks_managed_node_group_defaults = {
    ami_type               = "AL2_x86_64"
    disk_size              = 50
    instance_types         = ["t3.large"]
    vpc_security_group_ids = []
  }

  eks_managed_node_groups = {
    default = {
      min_size     = 1
      max_size     = 5
      desired_size = 4

      instance_types = ["t3.large"]
      capacity_type  = "SPOT"
    }
  }

  # Fargate Profile(s)
  #   fargate_profiles = {
  #     default = {
  #       name = "default"
  #       selectors = [
  #         {
  #           namespace = "kube-system"
  #           labels = {
  #             k8s-app = "kube-dns"
  #           }
  #         },
  #         {
  #           namespace = "default"
  #         }
  #       ]

  #       tags = {
  #         Owner = "test"
  #       }

  #       timeouts = {
  #         create = "20m"
  #         delete = "20m"
  #       }
  #     }
  #   }

  #   tags = {
  #     Environment = "dev"
  #     Terraform   = "true"
  #   }
}

resource "aws_security_group" "additional" {
  name_prefix = "eks-additional-sg"
  vpc_id      = var.vpc_id

  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"
    cidr_blocks = [
      "10.0.0.0/8",
      "172.16.0.0/12",
      "192.168.0.0/16",
      "10.1.1.0/24",
    ]
  }
}

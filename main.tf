terraform {
  cloud {
    organization = "global-architecture"
    workspaces {
      name = "global-arch-eks-terraform"
    }
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.72"
    }
  }
}

provider "aws" {
  region = "us-west-2"
  alias  = "us-west-2"
}

provider "aws" {
  region = "ap-southeast-1"
  alias  = "ap-southeast-1"
}

provider "aws" {
  region = "eu-west-2"
  alias  = "eu-west-2"
}

module "us-west-2" {
  source     = "./modules/eks"
  cluster_name =  var.cluster_name
  # ec2_key_name      = var.us_west_2_ec2_key_name
  # ec2_count         = 3
  # ec2_instance_type = "t3.large"
  # subnet_id         = module.us-west-2-infra.subnet.id
  # vpc_id            = module.us-west-2-infra.vpc.id
  # vpc_cidr          = var.US_vpc
  # peer_vpc_cidr     = var.SGP_vpc

  providers = {
    aws = aws.us-west-2
  }
}

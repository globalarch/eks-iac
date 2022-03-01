terraform {
  cloud {
    organization = "global-architecture"
    workspaces {
      name = "global-arch-infra"
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
  source            = "./modules/mongo"
  ec2_key_name      = var.us_west_2_ec2_key_name
  ec2_count         = 3
  ec2_instance_type = "t3.micro"
  subnet_id         = module.us-west-2-infra.subnet.id
  vpc_id            = module.us-west-2-infra.vpc.id
  vpc_cidr          = var.US_vpc
  peer_vpc_cidr     = var.SGP_vpc

  providers = {
    aws = aws.us-west-2
  }
}

module "ap-southeast-1" {
  source            = "./modules/mongo"
  ec2_key_name      = var.ap_southeast_1_ec2_key_name
  ec2_count         = 3
  ec2_instance_type = "t2.micro"
  subnet_id         = module.ap-southeast-1-infra.subnet.id
  vpc_id            = module.ap-southeast-1-infra.vpc.id
  vpc_cidr          = var.SGP_vpc
  peer_vpc_cidr     = var.US_vpc

  providers = {
    aws = aws.ap-southeast-1
  }
}

# module "eu-west-2" {
#   source            = "./modules/mongo"
#   ec2_key_name      = var.eu_west_2_ec2_key_name
#   ec2_count         = 3
#   ec2_instance_type = "t2.micro"
#   vpc_id = module.ap-southeast-1-infra.vpc.id

#   providers = {
#     aws = aws.eu-west-2
#   }
# }

module "us-west-2-eks" {
  source       = "./modules/eks"
  cluster_name = var.cluster_name
  subnet_id    = module.us-west-2-infra.subnet.id
  subnet_id_2  = module.us-west-2-infra.subnet_2.id
  vpc_id       = module.us-west-2-infra.vpc.id
  providers = {
    aws = aws.us-west-2
  }
}

module "ap-southeast-1-eks" {
  source       = "./modules/eks"
  cluster_name = var.cluster_name
  subnet_id    = module.ap-southeast-1-infra.subnet.id
  subnet_id_2  = module.ap-southeast-1-infra.subnet_2.id
  vpc_id       = module.ap-southeast-1-infra.vpc.id
  providers = {
    aws = aws.ap-southeast-1
  }
}


module "us-west-2-infra" {
  source                = "./modules/infra"
  ec2_key_name          = var.us_west_2_ec2_key_name
  private_subnet_cidr   = var.US_private_subnet
  private_subnet_cidr_2 = var.US_private_subnet_2
  vpc_cidr              = var.US_vpc
  peer_vpc_cidr         = var.SGP_vpc
  nginx                 = var.US_nginx
  region                = "us"
  availability_zone_1   = "us-west-2a"
  availability_zone_2   = "us-west-2b"
  availability_zone_3   = "us-west-2c"

  providers = {
    aws = aws.us-west-2
  }
}

module "ap-southeast-1-infra" {
  source                = "./modules/infra"
  ec2_key_name          = var.ap_southeast_1_ec2_key_name
  private_subnet_cidr   = var.SGP_private_subnet
  private_subnet_cidr_2 = var.SGP_private_subnet_2
  vpc_cidr              = var.SGP_vpc
  peer_vpc_cidr         = var.US_vpc
  nginx                 = var.SGP_nginx
  region                = "sgp"
  availability_zone_1   = "ap-southeast-1a"
  availability_zone_2   = "ap-southeast-1b"
  availability_zone_3   = "ap-southeast-1c"

  providers = {
    aws = aws.ap-southeast-1
  }
}

data "aws_caller_identity" "sgp" {
  provider = aws.ap-southeast-1
}

module "owner" {
  source         = "./modules/peering_owner"
  sgp_vpc_id     = module.ap-southeast-1-infra.vpc.id
  us_vpc_id      = module.us-west-2-infra.vpc.id
  sgp_cidr       = var.SGP_vpc
  route_table_id = module.us-west-2-infra.route_table_id
  account_id     = data.aws_caller_identity.sgp.account_id
  providers = {
    aws = aws.us-west-2
  }
}

module "accepter" {
  source                    = "./modules/peering_accepter"
  vpc_peering_connection_id = module.owner.vpc_peering_connection_id
  us_cidr                   = var.US_vpc
  route_table_id            = module.ap-southeast-1-infra.route_table_id
  providers = {
    aws = aws.ap-southeast-1
  }
}

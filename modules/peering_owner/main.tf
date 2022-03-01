terraform {
  required_providers {
    cloudinit = {
      source  = "hashicorp/cloudinit"
      version = "2.2.0"
    }
    aws = {
      source  = "hashicorp/aws"
      version = ">= 2.7.0"
    }
  }
}

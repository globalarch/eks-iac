terraform {
  required_providers {
    cloudinit = {
      source  = "hashicorp/cloudinit"
      version = "2.2.0"
    }
  }
}

locals {
  mongo_xfs_device = "/dev/xvdf"
  mongo_xfs_label  = "mongodata"
  mongo_mount_path = "/${local.mongo_xfs_label}"
}

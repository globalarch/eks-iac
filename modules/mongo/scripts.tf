data "cloudinit_config" "mongo" {
  gzip          = true
  base64_encode = true

  part {
    content_type = "text/cloud-config"
    content = templatefile("${path.module}/scripts/mongo.tpl", {
      actual_dev_name = "/dev/nvme1n1"
      xfs_dev         = "${local.mongo_xfs_device}"
      fs_label        = "${local.mongo_xfs_label}"
      mount_path      = "${local.mongo_mount_path}"
    })
  }
}

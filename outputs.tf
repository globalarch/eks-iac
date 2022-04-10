output "us_west_2_ips" {
  value = module.us-west-2-mongo.ips
}
output "ap_southeast_1_ips" {
  value = module.ap-southeast-1-mongo.ips
}

# output "eu_west_2_ips" {
#   value = module.eu-west-2.ips

output "inventory" {
  value = (yamlencode({
    all = {
      children = {
        "us-west-2" = {
          hosts = {
            for i, ip in module.us-west-2-mongo.ips : "us-west-2_${i}" => {
              ansible_host                 = ip["public"]
              ansible_ssh_private_key_file = var.us_west_2_private_key
              ec2_private_ip               = ip["private"]
            }
          }
        }

        "ap-southeast-1" = {
          hosts = {
            for i, ip in module.ap-southeast-1-mongo.ips : "ap-southeast-1_${i}" => {
              ansible_host                 = ip["public"]
              ansible_ssh_private_key_file = var.ap_southeast_1_private_key
              ec2_private_ip               = ip["private"]
            }
          }
        }

        "config-server" = {
          hosts = {
            "us-west-2_0"      = null
            "ap-southeast-1_0" = null
          }
        }

        "shard" = {
          hosts = {
            "us-west-2_1"      = null
            "ap-southeast-1_1" = null
            "us-west-2_2"      = null
            "ap-southeast-1_2" = null
            "us-west-2_3"      = null
            "ap-southeast-1_3" = null
          }
        }
      }

      vars = {
        # ansible_user = "ec2-user"
        ansible_user               = "ubuntu"
        ansible_python_interpreter = "/usr/bin/python2"
      }
    }
  }))
}

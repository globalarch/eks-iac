variable "us_west_2_ec2_key_name" {
  type    = string
  default = "terraform-cloud-us-west-2"
}

variable "us_west_2_private_key" {
  type    = string
  default = "./private_keys/terraform-cloud-us-west-2.pem"
}

variable "ap_southeast_1_ec2_key_name" {
  type    = string
  default = "terraform-cloud-ap-southeast-1"
}

variable "ap_southeast_1_private_key" {
  type    = string
  default = "./private_keys/terraform-cloud-ap-southeast-1.pem"
}

variable "eu_west_2_ec2_key_name" {
  type    = string
  default = "terraform-cloud-eu-west-2"
}

variable "US_private_subnet" {
  type    = string
  default = "10.1.1.0/24"
}
variable "US_mongo_private_ips" {
  default = {
    "0" = "10.1.1.20"
    "1" = "10.1.1.21"
    "2" = "10.1.1.22"
    "3" = "10.1.1.23"
    "4" = "10.1.1.24"
  }
}

variable "US_private_subnet_2" {
  type    = string
  default = "10.1.2.0/24"
}
variable "US_private_subnet_3" {
  type    = string
  default = "10.1.3.0/24"
}

variable "US_nginx" {
  type    = string
  default = "10.1.1.11"
}

variable "SGP_private_subnet" {
  type    = string
  default = "10.2.1.0/24"
}

variable "SGP_mongo_private_ips" {
  default = {
    "0" = "10.2.1.20"
    "1" = "10.2.1.21"
    "2" = "10.2.1.22"
    "3" = "10.2.1.23"
    "4" = "10.2.1.24"
  }
}

variable "SGP_private_subnet_2" {
  type    = string
  default = "10.2.2.0/24"
}

variable "SGP_private_subnet_3" {
  type    = string
  default = "10.2.3.0/24"
}

variable "SGP_nginx" {
  type    = string
  default = "10.2.1.11"
}

variable "account_id" {
  type    = string
  default = null
}

variable "SGP_vpc" {
  type    = string
  default = "10.2.0.0/16"
}

variable "US_vpc" {
  type    = string
  default = "10.1.0.0/16"
}

variable "eu_west_2_private_key" {
  type    = string
  default = "./private_keys/terraform-cloud-eu-west-2.pem"
}

variable "cluster_name" {
  type    = string
  default = "global-arch-tf"
}

variable "debug_cidrs" {
  type = list(any)
              #peem's static ip     #oregon-last-resort-eip
  default = ["124.120.245.173/32", "44.240.166.57/32", "58.8.64.252/32"]
}
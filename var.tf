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

variable "US_private_subnet_2" {
  type    = string
  default = "10.1.2.0/24"
}

variable "US_nginx" {
  type    = string
  default = "10.1.1.11"
}

variable "SGP_private_subnet" {
  type    = string
  default = "10.2.1.0/24"
}

variable "SGP_private_subnet_2" {
  type    = string
  default = "10.2.2.0/24"
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

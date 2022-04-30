variable "ec2_instance_type" {
  type    = string
  default = "t3.micro"
}

variable "ec2_ami" {
  type    = string
  default = null
}

variable "ec2_count" {
  type    = number
  default = 1
  validation {
    condition     = floor(var.ec2_count) == ceil(var.ec2_count) && var.ec2_count == floor(var.ec2_count)
    error_message = "Counting must be int."
  }
  validation {
    condition     = var.ec2_count > 0
    error_message = "Counting must more than zero."
  }
}

variable "ec2_key_name" {
  type    = string
  default = null
}

variable "subnet_id" {
  type    = string
  default = null
}

variable "vpc_id" {
  type    = string
  default = null
}

variable "vpc_cidr" {
  type    = string
  default = null
}

variable "peer_vpc_cidr" {
  type    = string
  default = null
}

variable "private_ips" {
  default = {}
}

variable "SGP_vpc" {
  type     = string
  nullable = false
}

variable "US_vpc" {
  type     = string
  nullable = false
}

variable "debug_cidrs" {
  type     = list(any)
  nullable = false
}

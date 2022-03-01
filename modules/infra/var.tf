variable "ubuntu-ami-sgp" {
  type    = string
  default = "ami-055d15d9cfddf7bd3"
}

variable "ubuntu-ami-us" {
  type    = string
  default = "ami-0892d3c7ee96c0bf7"
}

variable "ec2_instance_type" {
  type    = string
  default = "t3.micro"
}

variable "ec2_key_name" {
  type    = string
  default = null
}

variable "private_subnet_cidr" {
  type    = string
  default = null
}

variable "private_subnet_cidr_2" {
  type    = string
  default = null
}
variable "nginx" {
  type    = string
  default = null
}

variable "region" {
  type    = string
  default = null
}

variable "availability_zone_1" {
  type    = string
  default = null
}

variable "availability_zone_2" {
  type    = string
  default = null
}

variable "availability_zone_3" {
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

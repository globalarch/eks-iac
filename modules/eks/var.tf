variable "cluster_name" {
  type    = string
  default = null
}

variable "subnet_id" {
  type    = string
  default = null
}

variable "subnet_id_2" {
  type    = string
  default = null
}

variable "vpc_id" {
  type    = string
  default = null
}

variable "ssh_key" {
  type    = string
  default = null
}

variable "debug_cidrs" {
  type     = list(any)
  nullable = false
}

variable "SGP_vpc" {
  type     = string
  nullable = false
}

variable "US_vpc" {
  type     = string
  nullable = false
}
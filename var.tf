variable "subnet_ids" {
  type    = list(any)
  default = ["subnet-0c57da716a70cc369", "subnet-05ce2fc4f70abad30"]
}

variable "vpc_id" {
  type    = string
  default = "vpc-0bafe624007be0cca"
}

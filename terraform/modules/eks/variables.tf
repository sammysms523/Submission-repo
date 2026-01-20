variable "name" {}
variable "vpc_id" {}
variable "private_subnet_ids" {
  type = list(string)
}

variable "common_allowlist_cidr_blocks" {
  type = list(string)
}

variable "access_cidrs" {
  type = list(string)
}

variable "eks_version" {
  type    = string
  default = "1.32"
}

variable "aws_region" {
  type        = string
  description = "region of the aws"
}

variable "eks_ipv6_enabled" {
  type = bool
}

variable "vpc_ipv6_enabled" {
  type = bool
}

variable "environment" {
  type    = string
}

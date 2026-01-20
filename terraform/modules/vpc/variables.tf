variable "vpc_name" {}

variable "vpc_cidr" {
  default = "10.0.0.0/16"
}

variable "availability_zones" {
  type = list(string)
  default = [
    "ap-south-1a",
    "ap-south-1b"]
}

variable "private_subnets" {
  type    = list(string)
  default = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "public_subnets" {
  type    = list(string)
  default = ["10.0.3.0/24", "10.0.4.0/24"]
}

variable "kubernetes_cluster_name" {}


variable "vpc_ipv6_enabled" {
  type = bool
}
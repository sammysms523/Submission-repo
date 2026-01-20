module "vpc" {
  source = "../../modules/vpc"

  kubernetes_cluster_name = "Submission cluster live"
  vpc_name                = "Submission vpc live"
  vpc_ipv6_enabled        = var.vpc_ipv6_enabled

}

module "eks_cluster" {
  source = "../../modules/eks"

  name                         = "Submission cluster live"
  environment                  = var.env
  private_subnet_ids           = module.vpc.private_subnet_ids
  vpc_id                       = module.vpc.vpc_id
  common_allowlist_cidr_blocks = ["80.85.196.16/28", "80.85.196.32/29", "80.85.196.32/28", "3.70.78.136/32", "3.64.183.187/32", "18.156.44.238/32", "3.64.18.127/32", "18.158.222.138/32", "3.121.153.202/32", "3.73.186.156/32", "3.64.164.138/32", "3.123.124.72/32", "129.80.218.211/32"]
  access_cidrs                 = [module.vpc.vpc_cidr_block]
  aws_region                   = var.home_region
  vpc_ipv6_enabled             = var.vpc_ipv6_enabled
  eks_ipv6_enabled             = var.eks_ipv6_enabled
}
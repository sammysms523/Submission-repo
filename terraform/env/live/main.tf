# calling vpc and eks module to create vpc and eks cluster
module "vpc" {
  source = "../../modules/vpc"

  kubernetes_cluster_name = "Submission-cluster-live"
  vpc_name                = "Submission vpc live"
  vpc_ipv6_enabled        = var.vpc_ipv6_enabled

}

module "eks_cluster" {
  source = "../../modules/eks"

  name                         = "Submission-cluster-live"
  environment                  = var.env
  private_subnet_ids           = module.vpc.private_subnet_ids
  vpc_id                       = module.vpc.vpc_id
  common_allowlist_cidr_blocks = []
  access_cidrs                 = [module.vpc.vpc_cidr_block]
  aws_region                   = var.home_region
  vpc_ipv6_enabled             = var.vpc_ipv6_enabled
  eks_ipv6_enabled             = var.eks_ipv6_enabled
}